/**
 * Sanchala Clipboard Sync - Cross-device clipboard sharing
 */
import { EventEmitter } from 'events';
import * as crypto from 'crypto';

export interface ClipboardEntry {
  id: string; type: 'text' | 'image' | 'file' | 'html';
  content: string; preview?: string; size: number;
  source: string; timestamp: number; synced: boolean;
}

export interface SyncDevice {
  id: string; name: string; type: string; lastSync: number; online: boolean;
}

export interface ClipboardConfig {
  enabled: boolean; syncText: boolean; syncImages: boolean; syncFiles: boolean;
  maxSize: number; historySize: number; encryption: boolean;
}

export class ClipboardSync extends EventEmitter {
  private history: ClipboardEntry[] = [];
  private devices: Map<string, SyncDevice> = new Map();
  private config: ClipboardConfig = { enabled: true, syncText: true, syncImages: true, syncFiles: false, maxSize: 10485760, historySize: 100, encryption: true };
  private currentContent: ClipboardEntry | null = null;

  getConfig(): ClipboardConfig { return { ...this.config }; }
  updateConfig(updates: Partial<ClipboardConfig>): void { Object.assign(this.config, updates); this.emit('config-updated', this.config); }

  enable(): void { this.config.enabled = true; this.emit('enabled'); }
  disable(): void { this.config.enabled = false; this.emit('disabled'); }

  async copy(content: string, type: ClipboardEntry['type'] = 'text'): Promise<ClipboardEntry> {
    const entry: ClipboardEntry = {
      id: crypto.randomUUID(), type, content,
      preview: content.substring(0, 100),
      size: Buffer.byteLength(content), source: 'local',
      timestamp: Date.now(), synced: false
    };

    this.currentContent = entry;
    this.history.unshift(entry);
    if (this.history.length > this.config.historySize) this.history.pop();

    if (this.config.enabled) await this.syncToDevices(entry);
    this.emit('copied', entry);
    return entry;
  }

  async paste(): Promise<ClipboardEntry | null> {
    this.emit('pasted', this.currentContent);
    return this.currentContent;
  }

  private async syncToDevices(entry: ClipboardEntry): Promise<void> {
    for (const [id, device] of this.devices) {
      if (device.online) {
        entry.synced = true;
        device.lastSync = Date.now();
        this.emit('synced', { entry, device });
      }
    }
  }

  getHistory(): ClipboardEntry[] { return [...this.history]; }

  getEntry(id: string): ClipboardEntry | undefined {
    return this.history.find(e => e.id === id);
  }

  deleteEntry(id: string): boolean {
    const idx = this.history.findIndex(e => e.id === id);
    if (idx !== -1) { this.history.splice(idx, 1); return true; }
    return false;
  }

  clearHistory(): void { this.history = []; this.emit('history-cleared'); }

  pinEntry(id: string): void {
    const entry = this.history.find(e => e.id === id);
    if (entry) this.emit('pinned', entry);
  }

  registerDevice(name: string, type: string): SyncDevice {
    const device: SyncDevice = { id: crypto.randomUUID(), name, type, lastSync: Date.now(), online: true };
    this.devices.set(device.id, device);
    this.emit('device-registered', device);
    return device;
  }

  unregisterDevice(id: string): boolean { return this.devices.delete(id); }
  getDevices(): SyncDevice[] { return Array.from(this.devices.values()); }

  setDeviceOnline(id: string, online: boolean): void {
    const device = this.devices.get(id);
    if (device) { device.online = online; this.emit('device-status', device); }
  }

  async receiveFromDevice(deviceId: string, entry: Omit<ClipboardEntry, 'id' | 'timestamp' | 'synced'>): Promise<void> {
    const received: ClipboardEntry = { ...entry, id: crypto.randomUUID(), timestamp: Date.now(), synced: true };
    this.currentContent = received;
    this.history.unshift(received);
    this.emit('received', { entry: received, deviceId });
  }

  search(query: string): ClipboardEntry[] {
    return this.history.filter(e => e.content.toLowerCase().includes(query.toLowerCase()));
  }
}

export default ClipboardSync;
