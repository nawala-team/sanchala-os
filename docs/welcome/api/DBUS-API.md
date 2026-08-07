# D-Bus API Reference

Complete D-Bus interface for Sanchala Welcome.

## Service Information

| Property | Value |
|----------|-------|
| Bus Name | `id.sanchala.Welcome1` |
| Object Path | `/id/sanchala/Welcome1` |
| Interface | `id.sanchala.Welcome1` |

## Methods

### Wizard Control

#### Launch
Start the welcome wizard.

```xml
<method name="Launch">
  <arg name="options" type="a{sv}" direction="in"/>
  <arg name="success" type="b" direction="out"/>
</method>
```

Options:
- `force` (boolean): Re-run even if completed
- `page` (string): Start at specific page

#### GetCurrentPage
Get current wizard page and progress.

```xml
<method name="GetCurrentPage">
  <arg name="page" type="s" direction="out"/>
  <arg name="progress" type="u" direction="out"/>
</method>
```

#### SetPageData
Save data for a page.

```xml
<method name="SetPageData">
  <arg name="page" type="s" direction="in"/>
  <arg name="data" type="s" direction="in"/>  <!-- JSON -->
  <arg name="success" type="b" direction="out"/>
</method>
```

#### NavigateNext / NavigateBack
Navigate between pages.

```xml
<method name="NavigateNext">
  <arg name="new_page" type="s" direction="out"/>
</method>

<method name="NavigateBack">
  <arg name="new_page" type="s" direction="out"/>
</method>
```

#### SkipPage
Skip current page (if skippable).

```xml
<method name="SkipPage">
  <arg name="success" type="b" direction="out"/>
</method>
```

### Tour Control

#### StartTour
Begin a feature tour.

```xml
<method name="StartTour">
  <arg name="tour_id" type="s" direction="in"/>
  <arg name="success" type="b" direction="out"/>
</method>
```

#### GetAvailableTours
List available tours.

```xml
<method name="GetAvailableTours">
  <arg name="tours" type="a(sss)" direction="out"/>  <!-- id, name, description -->
</method>
```

#### TourNext / TourPrevious / TourExit
Tour navigation.

```xml
<method name="TourNext"/>
<method name="TourPrevious"/>
<method name="TourExit"/>
```

### Tips

#### GetNextTip
Get contextual tip.

```xml
<method name="GetNextTip">
  <arg name="context" type="s" direction="in"/>
  <arg name="tip_json" type="s" direction="out"/>
</method>
```

#### DismissTip
Dismiss a tip.

```xml
<method name="DismissTip">
  <arg name="tip_id" type="s" direction="in"/>
  <arg name="forever" type="b" direction="in"/>
</method>
```

### State

#### IsFirstBootComplete
Check if setup is complete.

```xml
<method name="IsFirstBootComplete">
  <arg name="complete" type="b" direction="out"/>
</method>
```

#### Reset
Reset all welcome state.

```xml
<method name="Reset"/>
```

## Signals

#### PageChanged
Emitted when wizard page changes.

```xml
<signal name="PageChanged">
  <arg name="page" type="s"/>
  <arg name="progress" type="u"/>  <!-- 0-100 -->
</signal>
```

#### SetupComplete
Emitted when setup finishes.

```xml
<signal name="SetupComplete">
  <arg name="duration_secs" type="u"/>
</signal>
```

#### TourStepChanged
Emitted during tour navigation.

```xml
<signal name="TourStepChanged">
  <arg name="tour_id" type="s"/>
  <arg name="step" type="u"/>
  <arg name="total" type="u"/>
</signal>
```

#### TipAvailable
Emitted when a tip is ready to show.

```xml
<signal name="TipAvailable">
  <arg name="tip_id" type="s"/>
  <arg name="context" type="s"/>
</signal>
```

## Example Usage

### Python (pydbus)

```python
from pydbus import SessionBus

bus = SessionBus()
welcome = bus.get("id.sanchala.Welcome1")

# Check if setup complete
if not welcome.IsFirstBootComplete():
    welcome.Launch({"force": False})

# Start tour
welcome.StartTour("desktop")

# Get tip
tip = welcome.GetNextTip("first_login")
print(tip)
```

### Shell (dbus-send)

```bash
# Check first boot
dbus-send --session --print-reply \
  --dest=id.sanchala.Welcome1 \
  /id/sanchala/Welcome1 \
  id.sanchala.Welcome1.IsFirstBootComplete

# Start tour
dbus-send --session \
  --dest=id.sanchala.Welcome1 \
  /id/sanchala/Welcome1 \
  id.sanchala.Welcome1.StartTour string:"desktop"
```

---

**Document Version:** 1.0
