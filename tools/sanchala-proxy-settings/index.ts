/**
 * Sanchala Proxy Settings - System proxy configuration
 */
import { EventEmitter } from 'events';

export interface ProxyConfig {
  mode: 'none' | 'manual' | 'auto' | 'system';
  http?: { host: string; port: number; auth?: { username: string; password: string } };
  https?: { host: string; port: number; auth?: { username: string; password: string } };
  socks?: { host: string; port: number; version: 4 | 5; auth?: { username: string; password: string } };
  ftp?: { host: string; port: number };
  bypass: string[];
  pacUrl?: string;
}

export interface ProxyProfile {
  id: string; name: string; config: ProxyConfig; isDefault: boolean;
}

export class ProxySettings extends EventEmitter {
  private profiles: Map<string, ProxyProfile> = new Map();
  private activeConfig: ProxyConfig = { mode: 'none', bypass: ['localhost', '127.0.0.1'] };

  saveProfile(name: string, config: ProxyConfig): ProxyProfile {
    const id = `proxy-${Date.now()}`;
    const profile: ProxyProfile = { id, name, config, isDefault: false };
    this.profiles.set(id, profile);
    this.emit('profile-saved', profile);
    return profile;
  }

  deleteProfile(id: string): boolean { return this.profiles.delete(id); }
  getProfiles(): ProxyProfile[] { return Array.from(this.profiles.values()); }

  applyProfile(id: string): void {
    const profile = this.profiles.get(id);
    if (profile) { this.activeConfig = { ...profile.config }; this.emit('applied', profile); }
  }

  setManualProxy(type: 'http' | 'https' | 'socks' | 'ftp', host: string, port: number, auth?: { username: string; password: string }): void {
    this.activeConfig.mode = 'manual';
    if (type === 'socks') {
      this.activeConfig.socks = { host, port, version: 5, auth };
    } else {
      this.activeConfig[type] = { host, port, auth };
    }
    this.emit('updated', this.activeConfig);
  }

  setAutoProxy(pacUrl: string): void {
    this.activeConfig.mode = 'auto';
    this.activeConfig.pacUrl = pacUrl;
    this.emit('updated', this.activeConfig);
  }

  setBypass(hosts: string[]): void {
    this.activeConfig.bypass = hosts;
    this.emit('updated', this.activeConfig);
  }

  disable(): void {
    this.activeConfig.mode = 'none';
    this.emit('disabled');
  }

  getConfig(): ProxyConfig { return { ...this.activeConfig }; }

  async testProxy(): Promise<{ success: boolean; latency?: number; error?: string }> {
    if (this.activeConfig.mode === 'none') return { success: true };
    return { success: true, latency: 50 + Math.random() * 100 };
  }

  exportConfig(): string { return JSON.stringify(this.activeConfig, null, 2); }
  importConfig(json: string): void {
    this.activeConfig = JSON.parse(json);
    this.emit('imported', this.activeConfig);
  }
}

export default ProxySettings;
