/**
 * Sanchala Captive Portal - Network portal detection and authentication
 */
import { EventEmitter } from 'events';
import * as crypto from 'crypto';

export interface PortalInfo {
  detected: boolean; url?: string; type?: 'login' | 'terms' | 'payment' | 'unknown';
  ssid?: string; venue?: string; provider?: string;
}

export interface SavedCredential {
  id: string; ssid: string; username?: string; password?: string;
  autoLogin: boolean; lastUsed?: number;
}

export interface PortalSession {
  id: string; ssid: string; startTime: number; authenticated: boolean;
  expiresAt?: number; bytesUsed?: number; timeLimit?: number;
}

export class CaptivePortal extends EventEmitter {
  private credentials: Map<string, SavedCredential> = new Map();
  private currentSession: PortalSession | null = null;
  private checkUrl = 'http://connectivitycheck.gstatic.com/generate_204';

  async detect(): Promise<PortalInfo> {
    // Simulate portal detection
    const hasPortal = Math.random() > 0.7;
    if (hasPortal) {
      const info: PortalInfo = {
        detected: true, url: 'http://portal.wifi.local/login',
        type: 'login', ssid: 'Coffee_WiFi', venue: 'Coffee Shop', provider: 'WiFi Provider Inc.'
      };
      this.emit('portal-detected', info);
      return info;
    }
    return { detected: false };
  }

  async authenticate(portalUrl: string, credentials?: { username?: string; password?: string }): Promise<boolean> {
    this.emit('authenticating', portalUrl);
    await new Promise(r => setTimeout(r, 1000));

    this.currentSession = {
      id: crypto.randomUUID(), ssid: 'Coffee_WiFi', startTime: Date.now(),
      authenticated: true, expiresAt: Date.now() + 3600000, timeLimit: 3600
    };
    this.emit('authenticated', this.currentSession);
    return true;
  }

  async acceptTerms(portalUrl: string): Promise<boolean> {
    this.emit('terms-accepted', portalUrl);
    return this.authenticate(portalUrl);
  }

  saveCredentials(ssid: string, username?: string, password?: string, autoLogin = true): SavedCredential {
    const cred: SavedCredential = { id: crypto.randomUUID(), ssid, username, password, autoLogin };
    this.credentials.set(ssid, cred);
    this.emit('credentials-saved', { ssid });
    return cred;
  }

  getCredentials(ssid: string): SavedCredential | undefined { return this.credentials.get(ssid); }
  getAllCredentials(): SavedCredential[] { return Array.from(this.credentials.values()); }
  deleteCredentials(ssid: string): boolean { return this.credentials.delete(ssid); }

  async autoLogin(ssid: string): Promise<boolean> {
    const cred = this.credentials.get(ssid);
    if (!cred?.autoLogin) return false;

    const portal = await this.detect();
    if (!portal.detected) return true;

    return this.authenticate(portal.url!, { username: cred.username, password: cred.password });
  }

  getSession(): PortalSession | null { return this.currentSession; }

  getSessionTimeRemaining(): number {
    if (!this.currentSession?.expiresAt) return -1;
    return Math.max(0, this.currentSession.expiresAt - Date.now());
  }

  async logout(): Promise<void> {
    if (this.currentSession) {
      this.currentSession.authenticated = false;
      this.emit('logged-out', this.currentSession);
      this.currentSession = null;
    }
  }

  async checkConnectivity(): Promise<boolean> {
    const portal = await this.detect();
    return !portal.detected;
  }

  setCheckUrl(url: string): void { this.checkUrl = url; }

  async openPortalPage(): Promise<string> {
    const portal = await this.detect();
    if (portal.url) { this.emit('portal-opened', portal.url); return portal.url; }
    throw new Error('No portal detected');
  }
}

export default CaptivePortal;
