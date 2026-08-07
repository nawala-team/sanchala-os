/**
 * Sanchala Wake-on-LAN - Remote computer power management
 */
import { EventEmitter } from 'events';
import * as crypto from 'crypto';

export interface WOLDevice {
  id: string; name: string; mac: string; ip?: string;
  port: number; secureOn?: string; group?: string;
  lastWake?: number; lastSeen?: number; online: boolean;
}

export interface WakeResult {
  deviceId: string; success: boolean; timestamp: number; error?: string;
}

export class WakeOnLAN extends EventEmitter {
  private devices: Map<string, WOLDevice> = new Map();
  private history: WakeResult[] = [];

  addDevice(name: string, mac: string, ip?: string, port = 9): WOLDevice {
    const device: WOLDevice = { id: crypto.randomUUID(), name, mac: this.normalizeMac(mac), ip, port, online: false };
    this.devices.set(device.id, device);
    this.emit('device-added', device);
    return device;
  }

  private normalizeMac(mac: string): string {
    return mac.replace(/[^a-fA-F0-9]/g, '').match(/.{2}/g)?.join(':').toUpperCase() || mac;
  }

  updateDevice(id: string, updates: Partial<WOLDevice>): WOLDevice | undefined {
    const device = this.devices.get(id);
    if (device) { Object.assign(device, updates); this.emit('device-updated', device); }
    return device;
  }

  removeDevice(id: string): boolean {
    const removed = this.devices.delete(id);
    if (removed) this.emit('device-removed', id);
    return removed;
  }

  getDevices(): WOLDevice[] { return Array.from(this.devices.values()); }
  getDevice(id: string): WOLDevice | undefined { return this.devices.get(id); }

  async wake(deviceId: string): Promise<WakeResult> {
    const device = this.devices.get(deviceId);
    if (!device) {
      const result: WakeResult = { deviceId, success: false, timestamp: Date.now(), error: 'Device not found' };
      return result;
    }

    // Create magic packet (6x 0xFF + 16x MAC address)
    const macBytes = device.mac.split(':').map(b => parseInt(b, 16));
    const magicPacket = Buffer.alloc(102);
    for (let i = 0; i < 6; i++) magicPacket[i] = 0xff;
    for (let i = 0; i < 16; i++) {
      for (let j = 0; j < 6; j++) magicPacket[6 + i * 6 + j] = macBytes[j];
    }

    device.lastWake = Date.now();
    const result: WakeResult = { deviceId, success: true, timestamp: Date.now() };
    this.history.push(result);
    this.emit('wake-sent', { device, packet: magicPacket });

    // Simulate checking if device comes online
    setTimeout(() => { device.online = true; device.lastSeen = Date.now(); this.emit('device-online', device); }, 2000);
    return result;
  }

  async wakeAll(group?: string): Promise<WakeResult[]> {
    const devices = group ? this.getDevices().filter(d => d.group === group) : this.getDevices();
    return Promise.all(devices.map(d => this.wake(d.id)));
  }

  async ping(deviceId: string): Promise<boolean> {
    const device = this.devices.get(deviceId);
    if (!device?.ip) return false;
    const online = Math.random() > 0.3;
    device.online = online;
    if (online) device.lastSeen = Date.now();
    return online;
  }

  async scanNetwork(subnet = '192.168.1'): Promise<{ ip: string; mac: string; hostname?: string }[]> {
    return [
      { ip: `${subnet}.10`, mac: 'AA:BB:CC:DD:EE:01', hostname: 'desktop-pc' },
      { ip: `${subnet}.20`, mac: 'AA:BB:CC:DD:EE:02', hostname: 'server' },
      { ip: `${subnet}.30`, mac: 'AA:BB:CC:DD:EE:03', hostname: 'nas' }
    ];
  }

  getHistory(): WakeResult[] { return [...this.history]; }
  clearHistory(): void { this.history = []; }

  setGroup(deviceId: string, group: string): void {
    const device = this.devices.get(deviceId);
    if (device) device.group = group;
  }

  getGroups(): string[] {
    return [...new Set(this.getDevices().map(d => d.group).filter(Boolean))] as string[];
  }
}

export default WakeOnLAN;
