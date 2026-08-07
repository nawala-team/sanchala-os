/**
 * Sanchala WiFi Analyzer - Wireless network analysis and optimization
 */

import { EventEmitter } from 'events';

export interface WiFiNetwork {
  ssid: string;
  bssid: string;
  channel: number;
  frequency: number;
  signal: number;
  quality: number;
  security: ('open' | 'wep' | 'wpa' | 'wpa2' | 'wpa3')[];
  band: '2.4GHz' | '5GHz' | '6GHz';
  width: 20 | 40 | 80 | 160;
  hidden: boolean;
  lastSeen: number;
}

export interface ChannelInfo {
  channel: number;
  frequency: number;
  band: string;
  networks: number;
  utilization: number;
  interference: 'low' | 'medium' | 'high';
}

export interface WiFiConnection {
  ssid: string;
  bssid: string;
  channel: number;
  signal: number;
  txRate: number;
  rxRate: number;
  connected: number;
  ip?: string;
}

export class WiFiAnalyzer extends EventEmitter {
  private networks: Map<string, WiFiNetwork> = new Map();
  private scanInterval: NodeJS.Timeout | null = null;
  private currentConnection: WiFiConnection | null = null;

  async scan(): Promise<WiFiNetwork[]> {
    const mockNetworks: WiFiNetwork[] = [
      { ssid: 'HomeNetwork', bssid: 'AA:BB:CC:DD:EE:01', channel: 6, frequency: 2437, signal: -45, quality: 85, security: ['wpa2'], band: '2.4GHz', width: 40, hidden: false, lastSeen: Date.now() },
      { ssid: 'HomeNetwork_5G', bssid: 'AA:BB:CC:DD:EE:02', channel: 36, frequency: 5180, signal: -55, quality: 70, security: ['wpa2', 'wpa3'], band: '5GHz', width: 80, hidden: false, lastSeen: Date.now() },
      { ssid: 'Neighbor_WiFi', bssid: 'AA:BB:CC:DD:EE:03', channel: 1, frequency: 2412, signal: -70, quality: 45, security: ['wpa2'], band: '2.4GHz', width: 20, hidden: false, lastSeen: Date.now() },
      { ssid: 'CoffeeShop', bssid: 'AA:BB:CC:DD:EE:04', channel: 11, frequency: 2462, signal: -80, quality: 25, security: ['open'], band: '2.4GHz', width: 20, hidden: false, lastSeen: Date.now() },
      { ssid: '', bssid: 'AA:BB:CC:DD:EE:05', channel: 44, frequency: 5220, signal: -65, quality: 55, security: ['wpa3'], band: '5GHz', width: 80, hidden: true, lastSeen: Date.now() }
    ];
    mockNetworks.forEach(n => this.networks.set(n.bssid, n));
    this.emit('scan-complete', mockNetworks);
    return mockNetworks;
  }

  startContinuousScan(interval = 5000): void {
    if (this.scanInterval) return;
    this.scanInterval = setInterval(() => this.scan(), interval);
  }

  stopContinuousScan(): void {
    if (this.scanInterval) { clearInterval(this.scanInterval); this.scanInterval = null; }
  }

  getNetworks(): WiFiNetwork[] { return Array.from(this.networks.values()); }

  analyzeChannels(band: '2.4GHz' | '5GHz' = '2.4GHz'): ChannelInfo[] {
    const channels = band === '2.4GHz' ? [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11] : [36, 40, 44, 48, 52, 56, 60, 64, 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 144, 149, 153, 157, 161, 165];
    const baseFreq = band === '2.4GHz' ? 2412 : 5180;
    
    return channels.map((ch, i) => {
      const nets = Array.from(this.networks.values()).filter(n => n.channel === ch).length;
      const util = Math.min(100, nets * 25 + Math.random() * 20);
      return {
        channel: ch, frequency: baseFreq + (i * (band === '2.4GHz' ? 5 : 20)),
        band, networks: nets, utilization: util,
        interference: util < 30 ? 'low' : util < 60 ? 'medium' : 'high'
      };
    });
  }

  recommendChannel(band: '2.4GHz' | '5GHz' = '2.4GHz'): ChannelInfo {
    const channels = this.analyzeChannels(band);
    return channels.sort((a, b) => a.utilization - b.utilization)[0];
  }

  async connect(ssid: string, password?: string): Promise<WiFiConnection> {
    const network = Array.from(this.networks.values()).find(n => n.ssid === ssid);
    if (!network) throw new Error(`Network ${ssid} not found`);
    if (network.security[0] !== 'open' && !password) throw new Error('Password required');

    this.currentConnection = {
      ssid: network.ssid, bssid: network.bssid, channel: network.channel,
      signal: network.signal, txRate: 150, rxRate: 300,
      connected: Date.now(), ip: '192.168.1.' + Math.floor(Math.random() * 200 + 10)
    };
    this.emit('connected', this.currentConnection);
    return this.currentConnection;
  }

  disconnect(): void {
    this.currentConnection = null;
    this.emit('disconnected');
  }

  getConnection(): WiFiConnection | null { return this.currentConnection; }

  getSignalHistory(bssid: string): { time: number; signal: number }[] {
    return Array.from({ length: 60 }, (_, i) => ({
      time: Date.now() - (59 - i) * 1000,
      signal: -50 + Math.sin(i / 10) * 10 + Math.random() * 5
    }));
  }
}

export default WiFiAnalyzer;
