# Documentation Style Guide

This guide establishes standards for all Sanchala OS documentation to ensure consistency, clarity, and quality.

---

## Table of Contents

- [General Principles](#general-principles)
- [Voice and Tone](#voice-and-tone)
- [Formatting](#formatting)
- [Code Examples](#code-examples)
- [File Organization](#file-organization)
- [Terminology](#terminology)

---

## General Principles

### Clarity First

- Write for humans, not machines
- Assume readers are intelligent but may be unfamiliar with the topic
- One idea per paragraph
- Use simple words when they work as well as complex ones

### Be Concise

- Remove unnecessary words
- Avoid filler phrases ("in order to" -> "to")
- Get to the point quickly
- Respect the reader's time

### Be Accurate

- Test all commands and code examples
- Keep information up-to-date
- Link to authoritative sources
- Admit limitations and unknowns

---

## Voice and Tone

### Use Active Voice

| Passive | Active |
|---------|--------|
| "The package is installed by pacman" | "Pacman installs the package" |
| "The file should be edited" | "Edit the file" |
| "Errors are logged by the system" | "The system logs errors" |

### Be Direct

| Indirect | Direct |
|----------|--------|
| "You might want to consider..." | "Consider..." |
| "It is recommended that..." | "We recommend..." |
| "Users should be aware that..." | "Note:" |

### Second Person (You)

Address the reader directly:

| Impersonal | Personal |
|------------|----------|
| "The user can configure..." | "You can configure..." |
| "One should ensure..." | "Ensure..." |

### Present Tense

| Future | Present |
|--------|--------|
| "This will install the package" | "This installs the package" |
| "The system will restart" | "The system restarts" |

### Friendly but Professional

- Be approachable without being casual
- Avoid jargon unless necessary (and explain it when used)
- Do not be condescending
- Match the branding voice: knowledgeable, supportive, warm

---

## Formatting

### Headings

Use heading hierarchy logically:

```markdown
# Document Title (H1 - only one per document)

## Major Section (H2)

### Subsection (H3)

#### Minor Subsection (H4)
```

- Use sentence case: "Installing the system" not "Installing The System"
- Keep headings short and descriptive
- Do not skip levels (H2 -> H4)

### Lists

**Bulleted lists** for unordered items:

```markdown
Features:
- Fast boot times
- Secure by default
- Beautiful interface
```

**Numbered lists** for sequences:

```markdown
Installation steps:
1. Download the ISO
2. Create bootable USB
3. Boot and install
```

### Emphasis

| Format | Usage | Example |
|--------|-------|--------|
| **Bold** | UI elements, important terms | Click **Apply** |
| *Italic* | Introducing terms, emphasis | The *sandboxing* feature... |
| `Code` | Commands, file names, values | Run `pacman -Syu` |

### Admonitions

Use blockquotes with prefixes for callouts:

```markdown
> **Note:** Additional helpful information.

> **Warning:** Something that could cause problems.

> **Tip:** A helpful suggestion.
```

---

## Code Examples

### Inline Code

Use backticks for:
- Commands: `sudo pacman -S package`
- File names: `~/.config/sanchala/settings.conf`
- Variable names: `$HOME`
- Values: `true`, `false`, `1024`

### Code Blocks

Always specify the language:

````markdown
```bash
#!/usr/bin/env bash
echo "Hello, Sanchala!"
```

```yaml
settings:
  theme: dark
  language: en
```
````

### Command Examples

Show both command and expected output when helpful:

```bash
$ uname -r
6.6.1-hardened1-1-hardened

$ pacman -Qi sanchala-guardian
Name            : sanchala-guardian
Version         : 1.0.0-1
```

Use `$` prefix for user commands, `#` for root commands.

### Placeholder Values

Use clear placeholders:

```bash
# Good - clear placeholder
ssh user@<your-server-ip>

# Good - descriptive
export API_KEY="your-api-key-here"
```

---

## File Organization

### Directory Structure

```
docs/
├── index.md                 # Documentation home
├── getting-started/         # Onboarding guides
│   ├── installation.md
│   ├── first-steps.md
│   └── faq.md
├── user-guide/              # End-user documentation
├── developer/               # Developer documentation
├── security/                # Security documentation
└── reference/               # Reference materials
```

### File Naming

- Use lowercase
- Use hyphens, not underscores: `installation-guide.md`
- Be descriptive: `troubleshooting-wifi.md` not `wifi.md`
- Use `.md` extension for Markdown

### Document Structure

Every document should have:

1. **Title** (H1)
2. **Brief introduction** (1-2 sentences)
3. **Table of contents** (for longer docs)
4. **Main content**
5. **Related links** (optional)

---

## Terminology

### Sanchala-Specific Terms

| Term | Usage |
|------|-------|
| Sanchala OS | Full name (not "SanchalaOS" or "sanchala") |
| Sanchala Guardian | Security center app |
| Sanchala TCC | Permission manager |
| NAWALA Ecosystem | Parent project family |

### Capitalization

- **Product names:** Sanchala OS, KDE Plasma, Arch Linux
- **Technologies:** Flatpak, AppArmor, Btrfs
- **Commands:** lowercase: `pacman`, `systemctl`

---

## Quality Checklist

Before submitting documentation:

- [ ] Spell-checked
- [ ] Links verified
- [ ] Code examples tested
- [ ] Screenshots up-to-date
- [ ] Follows this style guide
- [ ] Reviewed for accuracy

---

## Resources

- [Arch Wiki Style Guide](https://wiki.archlinux.org/title/Help:Style)
- [Google Developer Documentation Style Guide](https://developers.google.com/style)

---

**Document Version:** 1.0  
**Last Updated:** August 2026
