/**
 * Sanchala KVM Switch - Multi-computer keyboard/video/mouse control
 */
import { EventEmitter } from 'events';
import * as crypto from 'crypto';

export interface KVMComputer {
  id: string; name: string; ip?: string; port: number;
  position: 'left' | 'right' | 'top' | 'bottom';
  resolution: { width: number; height: number };
  connected: boolean; active: boolean;
}

export interface KVMConfig {
  mode: 'hardware' | 'software'; hotkey: string;
  mouseEdge: boolean; edgeDelay: number;
  clipboardShare: boolean; fileShare: boolean;
}

export interface InputEvent {
  type: 'keyboard' | 'mouse'; target: string;
  data: { key?: string; x?: number; y?: number; button?: number };
}

export class KVMSwitch extends EventEmitter {
  private computers: Map<string, KVMComputer> = new Map();
  private activeComputer: string | null = null;
  private config: KVMConfig = { mode: 'software', hotkey: 'Ctrl+Alt', mouseEdge: true, edgeDelay: 100, clipboardShare: true, fileShare: true };

  getConfig(): KVMConfig { return { ...this.config }; }
  updateConfig(updates: Partial<KVMConfig>): void { Object.assign(this.config, updates); this.emit('config-updated', this.config); }

  addComputer(name: string, position: KVMComputer['position'], ip?: string, port = 24800): KVMComputer {
    const computer: KVMComputer = {
      id: crypto.randomUUID(), name, ip, port, position,
      resolution: { width: 1920, height: 1080 }, connected: false, active: false
    };
    this.computers.set(computer.id, computer);
    this.emit('computer-added', computer);
    return computer;
  }

  removeComputer(id: string): boolean {
    const removed = this.computers.delete(id);
    if (removed) this.emit('computer-removed', id);
    return removed;
  }

  getComputers(): KVMComputer[] { return Array.from(this.computers.values()); }

  async connect(id: string): Promise<void> {
    const computer = this.computers.get(id);
    if (computer) {
      computer.connected = true;
      this.emit('connected', computer);
    }
  }

  async disconnect(id: string): Promise<void> {
    const computer = this.computers.get(id);
    if (computer) {
      computer.connected = false;
      computer.active = false;
      this.emit('disconnected', computer);
    }
  }

  switchTo(id: string): void {
    // Deactivate current
    if (this.activeComputer) {
      const current = this.computers.get(this.activeComputer);
      if (current) current.active = false;
    }

    // Activate new
    const target = this.computers.get(id);
    if (target && target.connected) {
      target.active = true;
      this.activeComputer = id;
      this.emit('switched', target);
    }
  }

  getActiveComputer(): KVMComputer | null {
    return this.activeComputer ? this.computers.get(this.activeComputer) || null : null;
  }

  handleInput(event: InputEvent): void {
    if (!this.activeComputer) return;
    this.emit('input', { ...event, target: this.activeComputer });
  }

  handleEdgeTransition(edge: 'left' | 'right' | 'top' | 'bottom'): void {
    if (!this.config.mouseEdge) return;

    const target = Array.from(this.computers.values()).find(c => c.position === edge && c.connected);
    if (target) {
      setTimeout(() => this.switchTo(target.id), this.config.edgeDelay);
    }
  }

  async shareClipboard(content: string): Promise<void> {
    if (!this.config.clipboardShare) return;
    this.emit('clipboard-shared', { content, targets: this.getComputers().filter(c => c.connected) });
  }

  async shareFile(path: string, targetId: string): Promise<void> {
    if (!this.config.fileShare) return;
    this.emit('file-shared', { path, target: targetId });
  }

  setHotkey(hotkey: string): void { this.config.hotkey = hotkey; }

  startServer(port = 24800): void { this.emit('server-started', port); }
  stopServer(): void { this.emit('server-stopped'); }
}

export default KVMSwitch;
