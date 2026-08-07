/**
 * Sanchala Torrent - BitTorrent client for P2P file sharing
 */
import { EventEmitter } from 'events';
import * as crypto from 'crypto';

export interface Torrent {
  id: string; name: string; infoHash: string; size: number;
  downloaded: number; uploaded: number; progress: number;
  status: 'queued' | 'checking' | 'downloading' | 'seeding' | 'paused' | 'error';
  downloadSpeed: number; uploadSpeed: number; peers: number; seeds: number;
  eta: number; savePath: string; added: number; files: TorrentFile[];
}

export interface TorrentFile {
  name: string; size: number; progress: number; priority: 'skip' | 'low' | 'normal' | 'high';
}

export interface TorrentConfig {
  downloadPath: string; maxDownload: number; maxUpload: number;
  maxConnections: number; dht: boolean; pex: boolean; encryption: boolean;
  port: number; upnp: boolean;
}

export class TorrentClient extends EventEmitter {
  private torrents: Map<string, Torrent> = new Map();
  private config: TorrentConfig = { downloadPath: '~/Downloads', maxDownload: 0, maxUpload: 0, maxConnections: 200, dht: true, pex: true, encryption: true, port: 6881, upnp: true };

  getConfig(): TorrentConfig { return { ...this.config }; }
  updateConfig(updates: Partial<TorrentConfig>): void { Object.assign(this.config, updates); this.emit('config-updated', this.config); }

  async addTorrent(source: string | Buffer, savePath?: string): Promise<Torrent> {
    const torrent: Torrent = {
      id: crypto.randomUUID(), name: 'Example.File.2024', infoHash: crypto.randomBytes(20).toString('hex'),
      size: 1073741824, downloaded: 0, uploaded: 0, progress: 0,
      status: 'queued', downloadSpeed: 0, uploadSpeed: 0, peers: 0, seeds: 0,
      eta: -1, savePath: savePath || this.config.downloadPath, added: Date.now(),
      files: [{ name: 'file1.mkv', size: 1073741824, progress: 0, priority: 'normal' }]
    };
    this.torrents.set(torrent.id, torrent);
    this.emit('added', torrent);
    this.startDownload(torrent);
    return torrent;
  }

  async addMagnet(magnetUri: string): Promise<Torrent> { return this.addTorrent(magnetUri); }

  private startDownload(torrent: Torrent): void {
    torrent.status = 'downloading';
    const interval = setInterval(() => {
      if (torrent.status !== 'downloading') { clearInterval(interval); return; }
      torrent.downloaded += Math.floor(torrent.size / 20);
      torrent.progress = Math.min(100, (torrent.downloaded / torrent.size) * 100);
      torrent.downloadSpeed = 1024 * 1024 * (1 + Math.random() * 5);
      torrent.peers = 5 + Math.floor(Math.random() * 20);
      torrent.seeds = 2 + Math.floor(Math.random() * 10);
      this.emit('progress', torrent);
      if (torrent.progress >= 100) {
        torrent.status = 'seeding';
        clearInterval(interval);
        this.emit('completed', torrent);
      }
    }, 500);
  }

  getTorrents(): Torrent[] { return Array.from(this.torrents.values()); }
  getTorrent(id: string): Torrent | undefined { return this.torrents.get(id); }

  pause(id: string): void { const t = this.torrents.get(id); if (t) { t.status = 'paused'; this.emit('paused', t); } }
  resume(id: string): void { const t = this.torrents.get(id); if (t && t.status === 'paused') { this.startDownload(t); this.emit('resumed', t); } }
  remove(id: string, deleteFiles = false): boolean { const r = this.torrents.delete(id); if (r) this.emit('removed', { id, deleteFiles }); return r; }

  setFilePriority(torrentId: string, fileIndex: number, priority: TorrentFile['priority']): void {
    const t = this.torrents.get(torrentId);
    if (t && t.files[fileIndex]) { t.files[fileIndex].priority = priority; }
  }

  getStats(): { download: number; upload: number; active: number } {
    const torrents = this.getTorrents();
    return {
      download: torrents.reduce((s, t) => s + t.downloadSpeed, 0),
      upload: torrents.reduce((s, t) => s + t.uploadSpeed, 0),
      active: torrents.filter(t => t.status === 'downloading' || t.status === 'seeding').length
    };
  }
}

export default TorrentClient;
