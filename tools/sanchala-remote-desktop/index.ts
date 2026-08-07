/**
 * Sanchala Remote Desktop - RDP/VNC client
 */
import { EventEmitter } from 'events';
import * as crypto from 'crypto';

export interface RemoteProfile {
  id: string; name: string; host: string; port: number;
  protocol: 'rdp' | 'vnc' | 'spice'; username?: string;
  resolution: { width: number; height: number }; colorDepth: number;
  fullscreen: boolean; clipboard: boolean; audio: boolean;
}

export interface RemoteSession {
  id: string; profileId: string; status: 'connecting' | 'connected' | 'disconnected';
  startTime: number; latency: number; fps: number;
}

export class RemoteDesktop extends EventEmitter {
  private profiles: Map<string, RemoteProfile> = new Map();
  private sessions: Map<string, RemoteSession> = new Map();

  saveProfile(p: Omit<RemoteProfile, 'id'>): RemoteProfile {
    const profile = { ...p, id: crypto.randomUUID() };
    this.profiles.set(profile.id, profile);
    return profile;
  }

  deleteProfile(id: string): boolean { return this.profiles.delete(id); }
  getProfiles(): RemoteProfile[] { return Array.from(this.profiles.values()); }

  async connect(profileId: string, password?: string): Promise<RemoteSession> {
    const profile = this.profiles.get(profileId);
    if (!profile) throw new Error('Profile not found');
    const session: RemoteSession = { id: crypto.randomUUID(), profileId, status: 'connecting', startTime: Date.now(), latency: 0, fps: 0 };
    this.sessions.set(session.id, session);
    await new Promise(r => setTimeout(r, 500));
    session.status = 'connected';
    session.latency = 15 + Math.random() * 20;
    session.fps = 30;
    this.emit('connected', session);
    return session;
  }

  async disconnect(sessionId: string): Promise<void> {
    const session = this.sessions.get(sessionId);
    if (session) { session.status = 'disconnected'; this.emit('disconnected', session); }
  }

  getSession(id: string): RemoteSession | undefined { return this.sessions.get(id); }
  getActiveSessions(): RemoteSession[] { return Array.from(this.sessions.values()).filter(s => s.status === 'connected'); }

  sendKeyEvent(sessionId: string, key: string, down: boolean): void { this.emit('key', { sessionId, key, down }); }
  sendMouseEvent(sessionId: string, x: number, y: number, buttons: number): void { this.emit('mouse', { sessionId, x, y, buttons }); }
  sendClipboard(sessionId: string, text: string): void { this.emit('clipboard-send', { sessionId, text }); }

  async takeScreenshot(sessionId: string): Promise<Buffer> {
    return Buffer.from('mock-screenshot-data');
  }

  setQuality(sessionId: string, quality: 'low' | 'medium' | 'high'): void {
    const session = this.sessions.get(sessionId);
    if (session) { session.fps = quality === 'low' ? 15 : quality === 'medium' ? 30 : 60; }
  }
}

export default RemoteDesktop;
