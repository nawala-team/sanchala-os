/**
 * Sanchala DNS Settings - DNS configuration and management
 */
import { EventEmitter } from 'events';

export interface DNSServer {
  id: string; name: string; primary: string; secondary?: string;
  type: 'standard' | 'doh' | 'dot'; provider?: string;
}

export interface DNSConfig {
  mode: 'auto' | 'manual';
  servers: string[];
  dohEnabled: boolean;
  dotEnabled: boolean;
  dnssec: boolean;
  cache: boolean;
  cacheSize: number;
}

export interface DNSRecord {
  name: string; type: string; ttl: number; value: string;
}

export class DNSSettings extends EventEmitter {
  private presets: DNSServer[] = [
    { id: 'google', name: 'Google DNS', primary: '8.8.8.8', secondary: '8.8.4.4', type: 'standard', provider: 'Google' },
    { id: 'cloudflare', name: 'Cloudflare', primary: '1.1.1.1', secondary: '1.0.0.1', type: 'doh', provider: 'Cloudflare' },
    { id: 'quad9', name: 'Quad9', primary: '9.9.9.9', secondary: '149.112.112.112', type: 'dot', provider: 'Quad9' },
    { id: 'opendns', name: 'OpenDNS', primary: '208.67.222.222', secondary: '208.67.220.220', type: 'standard', provider: 'Cisco' }
  ];
  private config: DNSConfig = { mode: 'auto', servers: [], dohEnabled: false, dotEnabled: false, dnssec: true, cache: true, cacheSize: 1000 };
  private cache: Map<string, { record: DNSRecord; expires: number }> = new Map();

  getPresets(): DNSServer[] { return this.presets; }
  getConfig(): DNSConfig { return { ...this.config }; }

  setServers(servers: string[]): void {
    this.config.mode = 'manual';
    this.config.servers = servers;
    this.emit('updated', this.config);
  }

  applyPreset(id: string): void {
    const preset = this.presets.find(p => p.id === id);
    if (preset) {
      this.config.servers = [preset.primary, preset.secondary].filter(Boolean) as string[];
      this.config.dohEnabled = preset.type === 'doh';
      this.config.dotEnabled = preset.type === 'dot';
      this.emit('applied', preset);
    }
  }

  enableDOH(enable: boolean): void { this.config.dohEnabled = enable; this.emit('updated', this.config); }
  enableDOT(enable: boolean): void { this.config.dotEnabled = enable; this.emit('updated', this.config); }
  enableDNSSEC(enable: boolean): void { this.config.dnssec = enable; this.emit('updated', this.config); }

  async lookup(hostname: string, type = 'A'): Promise<DNSRecord[]> {
    const cacheKey = `${hostname}:${type}`;
    const cached = this.cache.get(cacheKey);
    if (cached && cached.expires > Date.now()) return [cached.record];

    const record: DNSRecord = { name: hostname, type, ttl: 300, value: type === 'A' ? '93.184.216.34' : type === 'AAAA' ? '2606:2800:220:1:248:1893:25c8:1946' : 'example.com' };
    this.cache.set(cacheKey, { record, expires: Date.now() + record.ttl * 1000 });
    return [record];
  }

  async benchmark(): Promise<{ server: string; latency: number }[]> {
    return this.presets.map(p => ({ server: p.primary, latency: 10 + Math.random() * 50 }));
  }

  clearCache(): void { this.cache.clear(); this.emit('cache-cleared'); }
  getCacheStats(): { entries: number; size: number } { return { entries: this.cache.size, size: this.config.cacheSize }; }

  flushDNS(): void { this.clearCache(); this.emit('flushed'); }
}

export default DNSSettings;
