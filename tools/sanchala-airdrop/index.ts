/**
 * Sanchala AirDrop - Wireless file transfer between devices
 */
import { EventEmitter } from 'events';
import * as crypto from 'crypto';

export interface NearbyDevice {
  id: string; name: string; type: 'phone' | 'tablet' | 'computer' | 'unknown';
  platform: string; signal: number; lastSeen: number;
}

export interface Transfer {
  id: string; deviceId: string; direction: 'send' | 'receive';
  files: { name: string; size: number }[]; totalSize: number; transferred: number;
  status: 'pending' | 'accepted' | 'rejected' | 'active' | 'completed' | 'failed';
  startTime: number;
}

export interface AirDropConfig {
  enabled: boolean; visibility: 'off' | 'contacts' | 'everyone';
  deviceName: string; autoAccept: boolean; saveLocation: string;
}

export class AirDrop extends EventEmitter {
  private devices: Map<string, NearbyDevice> = new Map();
  private transfers: Map<string, Transfer> = new Map();
  private config: AirDropConfig = { enabled: true, visibility: 'contacts', deviceName: 'My Device', autoAccept: false, saveLocation: '~/Downloads' };
  private scanInterval: NodeJS.Timeout | null = null;

  getConfig(): AirDropConfig { return { ...this.config }; }
  setVisibility(v: AirDropConfig['visibility']): void { this.config.visibility = v; this.emit('config-changed', this.config); }
  setDeviceName(name: string): void { this.config.deviceName = name; }
  setAutoAccept(auto: boolean): void { this.config.autoAccept = auto; }
  setSaveLocation(path: string): void { this.config.saveLocation = path; }

  enable(): void { this.config.enabled = true; this.startDiscovery(); this.emit('enabled'); }
  disable(): void { this.config.enabled = false; this.stopDiscovery(); this.emit('disabled'); }

  startDiscovery(): void {
    if (this.scanInterval) return;
    this.scanInterval = setInterval(() => this.scan(), 3000);
    this.scan();
  }

  stopDiscovery(): void {
    if (this.scanInterval) { clearInterval(this.scanInterval); this.scanInterval = null; }
  }

  private scan(): void {
    const mockDevices: NearbyDevice[] = [
      { id: 'dev1', name: 'iPhone 15', type: 'phone', platform: 'iOS', signal: -45, lastSeen: Date.now() },
      { id: 'dev2', name: 'MacBook Pro', type: 'computer', platform: 'macOS', signal: -55, lastSeen: Date.now() }
    ];
    mockDevices.forEach(d => this.devices.set(d.id, d));
    this.emit('devices-updated', this.getNearbyDevices());
  }

  getNearbyDevices(): NearbyDevice[] { return Array.from(this.devices.values()); }

  async sendFiles(deviceId: string, files: { name: string; size: number; data?: Buffer }[]): Promise<Transfer> {
    const device = this.devices.get(deviceId);
    if (!device) throw new Error('Device not found');

    const transfer: Transfer = {
      id: crypto.randomUUID(), deviceId, direction: 'send',
      files: files.map(f => ({ name: f.name, size: f.size })),
      totalSize: files.reduce((s, f) => s + f.size, 0), transferred: 0,
      status: 'pending', startTime: Date.now()
    };
    this.transfers.set(transfer.id, transfer);
    this.emit('transfer-started', transfer);

    // Simulate acceptance and transfer
    setTimeout(() => { transfer.status = 'accepted'; this.emit('transfer-accepted', transfer); }, 500);
    setTimeout(() => { transfer.status = 'active'; this.simulateProgress(transfer); }, 1000);
    return transfer;
  }

  private simulateProgress(transfer: Transfer): void {
    const interval = setInterval(() => {
      transfer.transferred = Math.min(transfer.totalSize, transfer.transferred + transfer.totalSize / 10);
      this.emit('transfer-progress', transfer);
      if (transfer.transferred >= transfer.totalSize) {
        transfer.status = 'completed';
        clearInterval(interval);
        this.emit('transfer-completed', transfer);
      }
    }, 200);
  }

  acceptTransfer(id: string): void {
    const t = this.transfers.get(id);
    if (t && t.status === 'pending') { t.status = 'accepted'; this.emit('transfer-accepted', t); }
  }

  rejectTransfer(id: string): void {
    const t = this.transfers.get(id);
    if (t && t.status === 'pending') { t.status = 'rejected'; this.emit('transfer-rejected', t); }
  }

  cancelTransfer(id: string): void {
    const t = this.transfers.get(id);
    if (t) { t.status = 'failed'; this.emit('transfer-cancelled', t); }
  }

  getTransfers(): Transfer[] { return Array.from(this.transfers.values()); }
}

export default AirDrop;
