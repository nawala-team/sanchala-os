# 🌐 SANCHALA OS - Locale Defaults Configuration

## 1. Overview

This document defines the default locale settings for Sanchala OS across all supported regions, including date/time formats, number formats, and cultural conventions.

---

## 2. Supported Locales (50+)

### 2.1 Tier 1 - Full Support (Launch)

| Locale | Language | Region | RTL |
|--------|----------|--------|-----|
| en_US.UTF-8 | English | United States | No |
| en_GB.UTF-8 | English | United Kingdom | No |
| id_ID.UTF-8 | Indonesian | Indonesia | No |
| de_DE.UTF-8 | German | Germany | No |
| fr_FR.UTF-8 | French | France | No |
| es_ES.UTF-8 | Spanish | Spain | No |
| it_IT.UTF-8 | Italian | Italy | No |
| pt_BR.UTF-8 | Portuguese | Brazil | No |
| ru_RU.UTF-8 | Russian | Russia | No |
| ja_JP.UTF-8 | Japanese | Japan | No |
| ko_KR.UTF-8 | Korean | South Korea | No |
| zh_CN.UTF-8 | Chinese (Simp) | China | No |
| zh_TW.UTF-8 | Chinese (Trad) | Taiwan | No |
| ar_SA.UTF-8 | Arabic | Saudi Arabia | Yes |
| hi_IN.UTF-8 | Hindi | India | No |
| th_TH.UTF-8 | Thai | Thailand | No |
| vi_VN.UTF-8 | Vietnamese | Vietnam | No |
| nl_NL.UTF-8 | Dutch | Netherlands | No |
| pl_PL.UTF-8 | Polish | Poland | No |
| tr_TR.UTF-8 | Turkish | Turkey | No |

### 2.2 Tier 2 - Extended Support

```
cs_CZ, da_DK, el_GR, fi_FI, he_IL, hu_HU, nb_NO, ro_RO,
sk_SK, sv_SE, uk_UA, bg_BG, ca_ES, hr_HR, lt_LT, lv_LV,
sl_SI, sr_RS, et_EE, fa_IR, ms_MY, tl_PH, bn_BD, ta_IN,
te_IN, ml_IN, kn_IN, gu_IN, pa_IN, mr_IN
```

---

## 3. Format Specifications

### 3.1 Date Formats

| Locale | Short | Long | Example |
|--------|-------|------|---------|
| en_US | MM/dd/yyyy | MMMM d, yyyy | 08/15/2026 |
| en_GB | dd/MM/yyyy | d MMMM yyyy | 15/08/2026 |
| de_DE | dd.MM.yyyy | d. MMMM yyyy | 15.08.2026 |
| ja_JP | yyyy/MM/dd | yyyy年M月d日 | 2026/08/15 |
| ar_SA | dd/MM/yyyy | d MMMM yyyy | ١٥/٠٨/٢٠٢٦ |

### 3.2 Time Formats

| Locale | Format | Example |
|--------|--------|---------|
| en_US | 12-hour | 3:45 PM |
| en_GB | 24-hour | 15:45 |
| de_DE | 24-hour | 15:45 Uhr |
| ja_JP | 24-hour | 15時45分 |

### 3.3 Number Formats

| Locale | Decimal | Thousands | Example |
|--------|---------|-----------|---------|
| en_US | . | , | 1,234.56 |
| de_DE | , | . | 1.234,56 |
| fr_FR | , | (space) | 1 234,56 |

### 3.4 Currency Formats

| Locale | Symbol | Format | Example |
|--------|--------|--------|---------|
| en_US | $ | $#,##0.00 | $1,234.56 |
| id_ID | Rp | Rp#.##0 | Rp1.234 |
| de_DE | € | #.##0,00 € | 1.234,56 € |
| ja_JP | ¥ | ¥#,##0 | ¥1,234 |

---

## 4. System Configuration Files

### 4.1 Default /etc/locale.conf

```bash
# System-wide locale defaults
LANG=en_US.UTF-8
LC_COLLATE=C
LC_TIME=en_US.UTF-8
```

### 4.2 User Override ~/.config/locale.conf

```bash
# User-specific locale settings
LANG=id_ID.UTF-8
LC_TIME=id_ID.UTF-8
LC_MONETARY=id_ID.UTF-8
```

### 4.3 Generating Locales

```bash
# /etc/locale.gen - uncomment needed locales
en_US.UTF-8 UTF-8
id_ID.UTF-8 UTF-8
de_DE.UTF-8 UTF-8
ja_JP.UTF-8 UTF-8
ar_SA.UTF-8 UTF-8

# Generate
sudo locale-gen
```

---

## 5. Input Method Configuration

### 5.1 Fcitx5 (Default)

```ini
# ~/.config/fcitx5/profile
[Groups/0]
Name=Default
Default Layout=us
DefaultIM=keyboard-us

[Groups/0/Items/0]
Name=keyboard-us
Layout=

[Groups/0/Items/1]
Name=anthy
Layout=

[GroupOrder]
0=Default
```

### 5.2 Supported Input Methods

| Language | Input Method | Package |
|----------|--------------|---------|
| Japanese | Anthy/Mozc | fcitx5-anthy |
| Chinese | Pinyin | fcitx5-chinese-addons |
| Korean | Hangul | fcitx5-hangul |
| Vietnamese | Unikey | fcitx5-unikey |
| Thai | Thai | fcitx5-libthai |

---

## 6. Timezone Configuration

```bash
# /etc/localtime symlink
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime

# Common timezone mappings
id_ID → Asia/Jakarta
ja_JP → Asia/Tokyo
de_DE → Europe/Berlin
en_US → America/New_York (or user's choice)
```

---

## 7. First-Run Locale Selection

The installer and welcome app guide users through locale selection:

1. **Language** - UI language selection
2. **Region** - Country/territory
3. **Formats** - Date, time, number preferences
4. **Keyboard** - Layout and input method
5. **Timezone** - Auto-detected or manual

---

**Document Version:** 1.0 | **Last Updated:** August 2026
