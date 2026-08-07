# SANCHALA OS - Tiling Layouts Guide

## Layout Overview

### 1. Floating (Meta+Shift+F)
Traditional desktop - windows placed freely.

### 2. Master/Stack (Meta+Shift+M)
```
┌─────────────┬────────┐
│             │   2    │
│      1      ├────────┤
│   Master    │   3    │
│             ├────────┤
│             │   4    │
└─────────────┴────────┘
```
- Master: 55% width
- Stack: Remaining windows vertically stacked

### 3. Grid (Meta+Shift+G)
```
┌───────┬───────┐    ┌────┬────┬────┐
│   1   │   2   │    │ 1  │ 2  │ 3  │
├───────┼───────┤    ├────┼────┼────┤
│   3   │   4   │    │ 4  │ 5  │ 6  │
└───────┴───────┘    └────┴────┴────┘
   4 windows            6 windows
```
- Auto-calculates optimal grid

### 4. Golden Ratio (Meta+Shift+R)
```
┌───────────┬─────┐
│           │  2  │
│     1     ├──┬──┤
│           │3 │4 │
└───────────┴──┴──┘
```
- Primary: 61.8% (φ ratio)
- Spiral subdivision

### 5. Columns
```
┌────┬────┬────┬────┐
│    │    │    │    │
│ 1  │ 2  │ 3  │ 4  │
│    │    │    │    │
└────┴────┴────┴────┘
```
- Equal width columns

### 6. Rows
```
┌────────────────┐
│       1        │
├────────────────┤
│       2        │
├────────────────┤
│       3        │
└────────────────┘
```
- Equal height rows

### 7. Centered Master
```
┌────┬────────┬────┐
│ 2  │        │ 4  │
├────┤   1    ├────┤
│ 3  │ Master │ 5  │
└────┴────────┴────┘
```
- Master centered at 50%
- Side stacks flank

## Usage Tips

1. **Promote to Master**: `Meta+Return` moves focused window to master
2. **Cycle Layouts**: `Meta+T` cycles through all layouts
3. **Per-Desktop**: Each desktop remembers its layout
4. **Auto-Retile**: Windows automatically arrange when added/removed
