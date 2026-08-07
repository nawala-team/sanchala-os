/**
 * Sanchala Phone Link - Connect and sync with mobile devices
 */
import { EventEmitter } from 'events';
import * as crypto from 'crypto';

export interface LinkedPhone {
  id: string; name: string; model: string; platform: 'android' | 'ios';
  paired: number; lastSeen: number; battery: number; connected: boolean;
}

export interface PhoneNotification {
  id: string; phoneId: string; app: string; title: string;
  body: string; time: number; read: boolean;
}

export interface SMSMessage {
  id: string; phoneId: string; contact: string; body: string;
  time: number; direction: 'in' | 'out';
}

export interface PhoneLinkConfig {
  notifications: boolean; sms: boolean; calls: boolean;
  photos: boolean; clipboard: boolean; apps: boolean;
}

export class PhoneLink extends EventEmitter {
  private phones: Map<string, LinkedPhone> = new Map();
  private notifications: PhoneNotification[] = [];
  private messages: SMSMessage[] = [];
  private config: PhoneLinkConfig = { notifications: true, sms: true, calls: true, photos: true, clipboard: true, apps: true };

  getConfig(): PhoneLinkConfig { return { ...this.config }; }
  updateConfig(updates: Partial<PhoneLinkConfig>): void { Object.assign(this.config, updates); this.emit('config-updated', this.config); }

  async pairDevice(code: string): Promise<LinkedPhone> {
    const phone: LinkedPhone = {
      id: crypto.randomUUID(), name: 'My Phone', model: 'Pixel 8',
      platform: 'android', paired: Date.now(), lastSeen: Date.now(),
      battery: 85, connected: true
    };
    this.phones.set(phone.id, phone);
    this.emit('paired', phone);
    return phone;
  }

  unpairDevice(id: string): boolean {
    const removed = this.phones.delete(id);
    if (removed) this.emit('unpaired', id);
    return removed;
  }

  getLinkedPhones(): LinkedPhone[] { return Array.from(this.phones.values()); }

  async connect(phoneId: string): Promise<void> {
    const phone = this.phones.get(phoneId);
    if (phone) { phone.connected = true; phone.lastSeen = Date.now(); this.emit('connected', phone); }
  }

  async disconnect(phoneId: string): Promise<void> {
    const phone = this.phones.get(phoneId);
    if (phone) { phone.connected = false; this.emit('disconnected', phone); }
  }

  getNotifications(phoneId?: string): PhoneNotification[] {
    return phoneId ? this.notifications.filter(n => n.phoneId === phoneId) : this.notifications;
  }

  dismissNotification(id: string): void {
    const idx = this.notifications.findIndex(n => n.id === id);
    if (idx !== -1) { this.notifications.splice(idx, 1); this.emit('notification-dismissed', id); }
  }

  getMessages(phoneId: string): SMSMessage[] {
    return this.messages.filter(m => m.phoneId === phoneId);
  }

  async sendSMS(phoneId: string, contact: string, body: string): Promise<SMSMessage> {
    const msg: SMSMessage = { id: crypto.randomUUID(), phoneId, contact, body, time: Date.now(), direction: 'out' };
    this.messages.push(msg);
    this.emit('sms-sent', msg);
    return msg;
  }

  async getPhotos(phoneId: string, limit = 20): Promise<{ id: string; thumb: string; date: number }[]> {
    return Array.from({ length: limit }, (_, i) => ({ id: `photo-${i}`, thumb: `/photos/thumb-${i}.jpg`, date: Date.now() - i * 86400000 }));
  }

  async makeCall(phoneId: string, number: string): Promise<void> { this.emit('call-started', { phoneId, number }); }
  async endCall(phoneId: string): Promise<void> { this.emit('call-ended', phoneId); }

  async ringPhone(phoneId: string): Promise<void> { this.emit('ring', phoneId); }
  async getBattery(phoneId: string): Promise<number> { return this.phones.get(phoneId)?.battery || 0; }
}

export default PhoneLink;
