# ADB Functional Regression

Use this after the signed APK installs and launches. The goal is to prove that ads were cleaned without breaking normal user functions.

## Setup

Capture basic state:

```powershell
adb devices
adb shell pidof <package>
adb shell uiautomator dump /sdcard/window.xml
adb exec-out screencap -p > dist\screenshot_<label>.png
adb pull /sdcard/window.xml dist\window_<label>.xml
adb logcat -d > dist\logcat_<label>.txt
```

Use the local `adb.exe` path if platform-tools is bundled in the workspace.

## Discover User Functions

Infer features from:

- Visible tabs, buttons, labels, list rows, menus, and dialogs in `uiautomator` XML.
- Manifest activities with app package names.
- Screenshots from launch and navigation.
- Obvious domain concepts in resources and assets.

Group functions by what a real user can do, not by internal class names. Example groups for a reader app:

- Launch/home
- Bookshelf or library
- Search
- Categories/ranking/discovery
- Book detail
- Reader page
- Table of contents
- Settings/theme
- Profile/about/help
- Import/export/cache/source management

## Verify With ADB

For each key function:

1. Navigate to the entry point using taps, swipes, text input, or back/home key events.
2. Wait briefly for UI/network rendering.
3. Dump XML, screenshot, and logcat.
4. Check for crash, ANR, blank screen, repeated permission loop, blocked dialog, or no response.
5. Record the result.

Useful commands:

```powershell
adb shell input tap <x> <y>
adb shell input text "<query>"
adb shell input keyevent BACK
adb shell input swipe <x1> <y1> <x2> <y2> <duration_ms>
adb shell uiautomator dump /sdcard/window.xml
adb exec-out screencap -p > dist\screenshot_<function>.png
adb logcat -d -v time > dist\logcat_<function>.txt
```

## Result Table

Include a table like this in the final report:

| Function | Entry evidence | ADB actions | Result | Evidence files | Notes |
| --- | --- | --- | --- | --- | --- |
| Home | launch screenshot/XML | launch activity | Pass/Fail | screenshot, XML, logcat | |
| Search | search button/text field | tap, input text | Pass/Fail | screenshot, XML, logcat | |
| Reader | book/list item | tap, swipe | Pass/Fail | screenshot, XML, logcat | |

If a function needs login, private data, or unreliable network, mark it as `Partially verified` and explain what was verified locally.
