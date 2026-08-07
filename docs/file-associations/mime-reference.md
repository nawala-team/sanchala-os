# MIME type reference

Common MIME types and their file extensions used in Sanchala OS.

---

## Images

| MIME Type | Extensions | Default App |
|-----------|------------|-------------|
| `image/jpeg` | `.jpg`, `.jpeg` | Gwenview |
| `image/png` | `.png` | Gwenview |
| `image/gif` | `.gif` | Gwenview |
| `image/webp` | `.webp` | Gwenview |
| `image/svg+xml` | `.svg` | Inkscape |
| `image/tiff` | `.tiff`, `.tif` | Gwenview |
| `image/bmp` | `.bmp` | Gwenview |
| `image/heic` | `.heic` | Gwenview |
| `image/avif` | `.avif` | Gwenview |
| `image/x-xcf` | `.xcf` | GIMP |

---

## Documents

| MIME Type | Extensions | Default App |
|-----------|------------|-------------|
| `application/pdf` | `.pdf` | Okular |
| `application/epub+zip` | `.epub` | Okular |
| `application/x-mobipocket-ebook` | `.mobi` | Okular |
| `image/vnd.djvu` | `.djvu` | Okular |
| `application/x-cbz` | `.cbz` | Okular |
| `application/x-cbr` | `.cbr` | Okular |
| `application/postscript` | `.ps`, `.eps` | Okular |

---

## Office

| MIME Type | Extensions | Default App |
|-----------|------------|-------------|
| `application/vnd.oasis.opendocument.text` | `.odt` | LibreOffice Writer |
| `application/vnd.oasis.opendocument.spreadsheet` | `.ods` | LibreOffice Calc |
| `application/vnd.oasis.opendocument.presentation` | `.odp` | LibreOffice Impress |
| `application/msword` | `.doc` | LibreOffice Writer |
| `application/vnd.ms-excel` | `.xls` | LibreOffice Calc |
| `application/vnd.ms-powerpoint` | `.ppt` | LibreOffice Impress |
| `application/vnd.openxmlformats-officedocument.wordprocessingml.document` | `.docx` | LibreOffice Writer |
| `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet` | `.xlsx` | LibreOffice Calc |
| `application/vnd.openxmlformats-officedocument.presentationml.presentation` | `.pptx` | LibreOffice Impress |

---

## Video

| MIME Type | Extensions | Default App |
|-----------|------------|-------------|
| `video/mp4` | `.mp4`, `.m4v` | VLC |
| `video/x-matroska` | `.mkv` | VLC |
| `video/webm` | `.webm` | VLC |
| `video/x-msvideo` | `.avi` | VLC |
| `video/mpeg` | `.mpeg`, `.mpg` | VLC |
| `video/quicktime` | `.mov` | VLC |
| `video/x-flv` | `.flv` | VLC |
| `video/3gpp` | `.3gp` | VLC |

---

## Audio

| MIME Type | Extensions | Default App |
|-----------|------------|-------------|
| `audio/mpeg` | `.mp3` | VLC |
| `audio/flac` | `.flac` | VLC |
| `audio/ogg` | `.ogg` | VLC |
| `audio/opus` | `.opus` | VLC |
| `audio/aac` | `.aac` | VLC |
| `audio/mp4` | `.m4a` | VLC |
| `audio/wav` | `.wav` | VLC |
| `audio/x-ms-wma` | `.wma` | VLC |

---

## Archives

| MIME Type | Extensions | Default App |
|-----------|------------|-------------|
| `application/zip` | `.zip` | Ark |
| `application/x-tar` | `.tar` | Ark |
| `application/x-compressed-tar` | `.tar.gz`, `.tgz` | Ark |
| `application/x-bzip-compressed-tar` | `.tar.bz2` | Ark |
| `application/x-xz-compressed-tar` | `.tar.xz` | Ark |
| `application/x-7z-compressed` | `.7z` | Ark |
| `application/x-rar` | `.rar` | Ark |
| `application/gzip` | `.gz` | Ark |
| `application/zstd` | `.zst` | Ark |

---

## Text and code

| MIME Type | Extensions | Default App |
|-----------|------------|-------------|
| `text/plain` | `.txt` | Kate |
| `text/markdown` | `.md`, `.markdown` | Kate |
| `application/json` | `.json` | Kate |
| `application/x-yaml` | `.yml`, `.yaml` | Kate |
| `application/toml` | `.toml` | Kate |
| `text/x-python` | `.py` | Kate |
| `text/x-csrc` | `.c` | Kate |
| `text/x-c++src` | `.cpp`, `.cxx` | Kate |
| `text/x-chdr` | `.h` | Kate |
| `text/x-java` | `.java` | Kate |
| `text/x-rust` | `.rs` | Kate |
| `text/x-go` | `.go` | Kate |
| `text/javascript` | `.js` | Kate |
| `application/x-typescript` | `.ts`, `.tsx` | Kate |
| `text/css` | `.css` | Kate |
| `text/x-scss` | `.scss` | Kate |
| `application/x-shellscript` | `.sh`, `.bash` | Kate |

---

## Web

| MIME Type | Extensions | Default App |
|-----------|------------|-------------|
| `text/html` | `.html`, `.htm` | Brave |
| `application/xhtml+xml` | `.xhtml` | Brave |
| `application/xml` | `.xml` | Kate |
| `application/rss+xml` | `.rss` | Brave |

---

## Sanchala custom types

| MIME Type | Extensions | Default App |
|-----------|------------|-------------|
| `application/x-sanchala-config` | `.sanchala`, `.sanc` | Kate |
| `application/x-sanchala-theme` | `.santheme` | Theme Installer |
| `application/x-sanchala-backup` | `.sanbackup`, `.sbak` | Backup Manager |
| `application/x-sanchala-shortcut` | `.sanshortcut` | Kate |
| `application/x-sanchala-policy` | `.sanpolicy`, `.spol` | Guardian |
| `application/x-sanchala-audit-log` | `.sanaudit`, `.slog` | Kate |
| `application/x-sanchala-permission` | `.sanperm` | TCC |
| `application/x-sanchala-extension` | `.sanext`, `.sext` | Extension Installer |
| `application/x-sanchala-widget` | `.sanwidget`, `.swgt` | Widget Installer |
| `application/x-sanchala-project` | `.sanproj` | Kate |
| `application/x-sanchala-workspace` | `.sanwork` | Kate |

---

## URL schemes

| Scheme | Handler |
|--------|---------|
| `http://`, `https://` | Brave Browser |
| `mailto:` | KMail |
| `file://` | Dolphin |
| `trash://` | Dolphin |
| `ftp://`, `sftp://` | Dolphin |
| `ipfs://`, `ipns://` | Brave Browser |
| `sanchala://` | Sanchala Handler |
| `sanchala-settings://` | Sanchala Settings |
