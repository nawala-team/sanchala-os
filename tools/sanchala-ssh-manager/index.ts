/**
 * Sanchala SSH Manager - Secure shell connection management
 */
import { EventEmitter } from 'events';
import * as crypto from 'crypto';

export interface SSHProfile {
  id: string; name: string; host: string; port: number; username: string;
  authType: 'password' | 'key' | 'agent'; privateKeyPath?: string;
  jumpHost?: string; tags: string[]; lastConnected?: number;
}

export interface SSHSession {
  id: string; profileId: string; status: 'connecting' | 'connected' | 'disconnected';
  startTime: number; bytesIn: number; bytesOut: number;
}

export interface PortForward {
  id: string; sessionId: string; type: 'local' | 'remote' | 'dynamic';
  localPort: number; remoteHost?: string; remotePort?: number; active: boolean;
}

export class SSHManager extends EventEmitter {
  private profiles: Map<string, SSHProfile> = new Map();
  private sessions: Map<string, SSHSession> = new Map();
  private forwards: Map<string, PortForward> = new Map();

  saveProfile(p: Omit<SSHProfile, 'id'>): SSHProfile {
    const profile = { ...p, id: crypto.randomUUID(), tags: p.tags || [] };
    this.profiles.set(profile.id, profile);
    return profile;
  }

  deleteProfile(id: string): boolean { return this.profiles.delete(id); }
  getProfiles(): SSHProfile[] { return Array.from(this.profiles.values()); }

  async connect(profileId: string): Promise<SSHSession> {
    const profile = this.profiles.get(profileId);
    if (!profile) throw new Error('Profile not found');
    const session: SSHSession = { id: crypto.randomUUID(), profileId, status: 'connecting', startTime: Date.now(), bytesIn: 0, bytesOut: 0 };
    this.sessions.set(session.id, session);
    await new Promise(r => setTimeout(r, 300));
    session.status = 'connected';
    profile.lastConnected = Date.now();
    this.emit('connected', session);
    return session;
  }

  async disconnect(sessionId: string): Promise<void> {
    const session = this.sessions.get(sessionId);
    if (session) { session.status = 'disconnected'; this.emit('disconnected', session); }
  }

  getActiveSessions(): SSHSession[] { return Array.from(this.sessions.values()).filter(s => s.status === 'connected'); }

  async exec(sessionId: string, cmd: string): Promise<{ stdout: string; exitCode: number }> {
    const session = this.sessions.get(sessionId);
    if (!session || session.status !== 'connected') throw new Error('Not connected');
    return { stdout: `Executed: ${cmd}`, exitCode: 0 };
  }

  async addForward(sessionId: string, type: PortForward['type'], localPort: number, remoteHost?: string, remotePort?: number): Promise<PortForward> {
    const fwd: PortForward = { id: crypto.randomUUID(), sessionId, type, localPort, remoteHost, remotePort, active: true };
    this.forwards.set(fwd.id, fwd);
    return fwd;
  }

  removeForward(id: string): boolean { return this.forwards.delete(id); }
  getForwards(sessionId?: string): PortForward[] {
    const all = Array.from(this.forwards.values());
    return sessionId ? all.filter(f => f.sessionId === sessionId) : all;
  }

  exportConfig(): string {
    let cfg = '# SSH Config\n';
    for (const p of this.profiles.values()) {
      cfg += `Host ${p.name}\n  HostName ${p.host}\n  Port ${p.port}\n  User ${p.username}\n\n`;
    }
    return cfg;
  }
}

export default SSHManager;
