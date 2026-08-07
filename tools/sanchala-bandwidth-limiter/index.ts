/**
 * Sanchala Bandwidth Limiter - Network traffic shaping and QoS
 */
import { EventEmitter } from 'events';
import * as crypto from 'crypto';

export interface BandwidthRule {
  id: string; name: string; enabled: boolean;
  target: { type: 'app' | 'ip' | 'port' | 'interface'; value: string };
  limits: { download?: number; upload?: number };
  schedule?: { days: number[]; startTime: string; endTime: string };
  priority: 'low' | 'normal' | 'high'; created: number;
}

export interface UsageStats {
  ruleId: string; download: number; upload: number;
  throttled: number; period: 'realtime' | 'hourly' | 'daily';
}

export interface QoSProfile {
  id: string; name: string; rules: string[];
  isDefault: boolean;
}

export class BandwidthLimiter extends EventEmitter {
  private rules: Map<string, BandwidthRule> = new Map();
  private profiles: Map<string, QoSProfile> = new Map();
  private stats: Map<string, UsageStats> = new Map();
  private enabled = false;

  enable(): void { this.enabled = true; this.emit('enabled'); }
  disable(): void { this.enabled = false; this.emit('disabled'); }
  isEnabled(): boolean { return this.enabled; }

  addRule(rule: Omit<BandwidthRule, 'id' | 'created'>): BandwidthRule {
    const full: BandwidthRule = { ...rule, id: crypto.randomUUID(), created: Date.now() };
    this.rules.set(full.id, full);
    this.emit('rule-added', full);
    return full;
  }

  updateRule(id: string, updates: Partial<BandwidthRule>): BandwidthRule | undefined {
    const rule = this.rules.get(id);
    if (rule) { Object.assign(rule, updates); this.emit('rule-updated', rule); }
    return rule;
  }

  removeRule(id: string): boolean {
    const removed = this.rules.delete(id);
    if (removed) this.emit('rule-removed', id);
    return removed;
  }

  getRules(): BandwidthRule[] { return Array.from(this.rules.values()); }
  getRule(id: string): BandwidthRule | undefined { return this.rules.get(id); }

  enableRule(id: string): void { const r = this.rules.get(id); if (r) r.enabled = true; }
  disableRule(id: string): void { const r = this.rules.get(id); if (r) r.enabled = false; }

  createProfile(name: string, ruleIds: string[]): QoSProfile {
    const profile: QoSProfile = { id: crypto.randomUUID(), name, rules: ruleIds, isDefault: false };
    this.profiles.set(profile.id, profile);
    this.emit('profile-created', profile);
    return profile;
  }

  applyProfile(id: string): void {
    const profile = this.profiles.get(id);
    if (profile) {
      for (const rule of this.rules.values()) rule.enabled = profile.rules.includes(rule.id);
      this.emit('profile-applied', profile);
    }
  }

  getProfiles(): QoSProfile[] { return Array.from(this.profiles.values()); }

  setAppLimit(appName: string, download?: number, upload?: number): BandwidthRule {
    return this.addRule({ name: `Limit ${appName}`, enabled: true, target: { type: 'app', value: appName }, limits: { download, upload }, priority: 'normal' });
  }

  setGlobalLimit(download?: number, upload?: number): void {
    this.addRule({ name: 'Global Limit', enabled: true, target: { type: 'interface', value: '*' }, limits: { download, upload }, priority: 'normal' });
  }

  getStats(ruleId: string): UsageStats | undefined { return this.stats.get(ruleId); }

  getAllStats(): UsageStats[] {
    return this.getRules().map(r => ({
      ruleId: r.id, download: Math.floor(Math.random() * 1e8),
      upload: Math.floor(Math.random() * 5e7), throttled: Math.floor(Math.random() * 1e6), period: 'daily' as const
    }));
  }

  getActiveRules(): BandwidthRule[] {
    const now = new Date();
    return this.getRules().filter(r => {
      if (!r.enabled) return false;
      if (!r.schedule) return true;
      const day = now.getDay();
      const time = now.toTimeString().slice(0, 5);
      return r.schedule.days.includes(day) && time >= r.schedule.startTime && time <= r.schedule.endTime;
    });
  }
}

export default BandwidthLimiter;
