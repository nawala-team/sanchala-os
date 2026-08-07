# Application Mapping Guide

Find Linux alternatives for your Windows and macOS applications.

## Office & Productivity

| Windows/macOS App | Sanchala OS Alternative | Notes |
|-------------------|------------------------|-------|
| Microsoft Word | LibreOffice Writer | Full .docx support |
| Microsoft Excel | LibreOffice Calc | Full .xlsx support |
| Microsoft PowerPoint | LibreOffice Impress | Full .pptx support |
| Microsoft Outlook | Thunderbird | Email + Calendar |
| Microsoft OneNote | Joplin, Obsidian | Markdown notes |
| Apple Pages | LibreOffice Writer | Export to .odt first |
| Apple Numbers | LibreOffice Calc | Export to .xlsx first |
| Apple Keynote | LibreOffice Impress | Export to .pptx first |
| Notion | Obsidian, Logseq | Local-first alternatives |

## Web Browsers

| Windows/macOS App | Sanchala OS Alternative | Notes |
|-------------------|------------------------|-------|
| Google Chrome | Chrome, Brave, Firefox | Chrome works on Linux |
| Microsoft Edge | Firefox, Brave | Edge available via Flatpak |
| Safari | Firefox | Best privacy option |

## Media Players

| Windows/macOS App | Sanchala OS Alternative | Notes |
|-------------------|------------------------|-------|
| Windows Media Player | VLC, Elisa | VLC plays everything |
| iTunes | Elisa, Strawberry | For music playback |
| Apple Music | Spotify, Cider | Cider for Apple Music |
| Spotify | Spotify | Native Linux app |

## Image & Video Editing

| Windows/macOS App | Sanchala OS Alternative | Notes |
|-------------------|------------------------|-------|
| Adobe Photoshop | GIMP, Krita | Krita for painting |
| Adobe Lightroom | darktable, RawTherapee | Professional RAW editing |
| Paint | KolourPaint | Simple drawing |
| Adobe Premiere | Kdenlive, DaVinci Resolve | DaVinci is pro-grade |
| Final Cut Pro | Kdenlive, DaVinci Resolve | Kdenlive is KDE native |
| iMovie | Kdenlive | Beginner friendly |

## Development

| Windows/macOS App | Sanchala OS Alternative | Notes |
|-------------------|------------------------|-------|
| Visual Studio | VS Code, Qt Creator | VS Code is cross-platform |
| Xcode | Qt Creator, GNOME Builder | For native development |
| Notepad++ | Kate, VS Code | Kate is KDE native |
| Terminal (macOS) | Konsole | KDE terminal |
| PowerShell | Bash, Fish, Zsh | Fish is user-friendly |

## File Management & Utilities

| Windows/macOS App | Sanchala OS Alternative | Notes |
|-------------------|------------------------|-------|
| File Explorer | Dolphin | KDE file manager |
| Finder | Dolphin | Similar functionality |
| WinRAR/7-Zip | Ark | KDE archive manager |
| Task Manager | System Monitor | KDE system monitor |
| Control Panel | System Settings | KDE settings |
| Snipping Tool | Spectacle | KDE screenshot tool |

## Communication

| Windows/macOS App | Sanchala OS Alternative | Notes |
|-------------------|------------------------|-------|
| Slack | Slack | Native Linux app |
| Discord | Discord | Native Linux app |
| Microsoft Teams | Teams | Via Flatpak/web |
| Zoom | Zoom | Native Linux app |
| iMessage | Signal, Element | No iMessage on Linux |

## Cloud Storage

| Windows/macOS App | Sanchala OS Alternative | Notes |
|-------------------|------------------------|-------|
| OneDrive | rclone, Insync | Third-party sync |
| iCloud | Nextcloud | Self-hosted alternative |
| Google Drive | rclone, Insync | Official client lacking |
| Dropbox | Dropbox | Native Linux client |

## Gaming

| Windows/macOS App | Sanchala OS Alternative | Notes |
|-------------------|------------------------|-------|
| Steam | Steam | Native + Proton for Windows games |
| Epic Games | Heroic Launcher | Third-party launcher |
| GOG Galaxy | Lutris, Heroic | Game management |

## Install Recommendations

### Pre-installed in Sanchala OS
- Firefox, LibreOffice, Dolphin, Kate, Gwenview, Elisa, VLC, Spectacle

### Recommended Additions

```bash
sudo pacman -S gimp kdenlive obs-studio steam discord
```

### Flatpak Apps

```bash
flatpak install flathub com.spotify.Client
flatpak install flathub com.slack.Slack
flatpak install flathub us.zoom.Zoom
```

## Wine for Windows Apps

Some Windows apps run via Wine:

```bash
sudo pacman -S wine wine-mono wine-gecko
wine /path/to/program.exe
```

Check [ProtonDB](https://www.protondb.com/) for game compatibility.

---

**Need a specific app?** Search [Sanchala Store](sanchala-store://) or ask on [forum.sanchala.id](https://forum.sanchala.id)
