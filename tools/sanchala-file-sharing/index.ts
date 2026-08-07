/**
 * Sanchala File Sharing - Local network file sharing
 */
import { EventEmitter } from 'events';
import * as crypto from 'crypto';

export interface SharedFolder {
  id: string; name: string; path: string; permissions: 'read' | 'write' | 'full';
  password?: string; users: string[]; active: boolean; created: number;
}

export interface ShareSession {
  id: string; folderId: string; user: string; ip: string;
  connected: number; bytesTransferred: number;
}

export interface ShareConfig {
  enabled: boolean; protocol: 'smb' | 'nfs' | 'webdav';
  workgroup: string; hostname: string; discoverable: boolean;
}

export class FileSharing extends EventEmitter {
  private folders: Map<string, SharedFolder> = new Map();
  private sessions: Map<string, ShareSession> = new Map();
  private config: ShareConfig = { enabled: false, protocol: 'smb', workgroup: 'WORKGROUP', hostname: 'sanchala-pc', discoverable: true };

  getConfig(): ShareConfig { return { ...this.config }; }

  enable(): void { this.config.enabled = true; this.emit('enabled'); }
  disable(): void { this.config.enabled = false; this.emit('disabled'); }

  setProtocol(protocol: ShareConfig['protocol']): void { this.config.protocol = protocol; }
  setWorkgroup(workgroup: string): void { this.config.workgroup = workgroup; }
  setDiscoverable(discoverable: boolean): void { this.config.discoverable = discoverable; }

  shareFolder(name: string, path: string, permissions: SharedFolder['permissions'], password?: string): SharedFolder {
    const folder: SharedFolder = { id: crypto.randomUUID(), name, path, permissions, password, users: [], active: true, created: Date.now() };
    this.folders.set(folder.id, folder);
    this.emit('shared', folder);
    return folder;
  }

  unshareFolder(id: string): boolean {
    const deleted = this.folders.delete(id);
    if (deleted) this.emit('unshared', id);
    return deleted;
  }

  updateFolder(id: string, updates: Partial<SharedFolder>): SharedFolder | undefined {
    const folder = this.folders.get(id);
    if (folder) { Object.assign(folder, updates); this.emit('updated', folder); }
    return folder;
  }

  getSharedFolders(): SharedFolder[] { return Array.from(this.folders.values()); }

  addUser(folderId: string, user: string): boolean {
    const folder = this.folders.get(folderId);
    if (folder && !folder.users.includes(user)) { folder.users.push(user); return true; }
    return false;
  }

  removeUser(folderId: string, user: string): boolean {
    const folder = this.folders.get(folderId);
    if (folder) { folder.users = folder.users.filter(u => u !== user); return true; }
    return false;
  }

  getSessions(): ShareSession[] { return Array.from(this.sessions.values()); }
  disconnectSession(id: string): boolean { return this.sessions.delete(id); }

  async discoverShares(): Promise<{ host: string; shares: string[] }[]> {
    return [
      { host: '192.168.1.50', shares: ['Documents', 'Media'] },
      { host: '192.168.1.51', shares: ['Public', 'Backup'] }
    ];
  }

  async mountShare(host: string, share: string, mountPoint: string, credentials?: { user: string; pass: string }): Promise<boolean> {
    this.emit('mounted', { host, share, mountPoint });
    return true;
  }

  async unmountShare(mountPoint: string): Promise<boolean> {
    this.emit('unmounted', mountPoint);
    return true;
  }
}

export default FileSharing;
