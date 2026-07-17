---
name: verify
description: Build, run and drive PantryPilot on the iOS simulator to verify a change end-to-end.
---

# Verifying PantryPilot changes

## Build & run

```bash
xcodegen generate   # after adding/removing files (`.xcodeproj` is generated, git-ignored)
xcodebuild build -project PantryPilot.xcodeproj -scheme PantryPilot \
  -destination 'platform=iOS Simulator,name=iPhone 17'
APP=$(find ~/Library/Developer/Xcode/DerivedData -name "PantryPilot.app" -path "*iphonesimulator*" | head -1)
xcrun simctl install booted "$APP" && xcrun simctl launch booted com.gurv.PantryPilot
xcrun simctl io booted screenshot out.png
```

## Driving the UI

Host-side clicking (osascript/cliclick) is unavailable here (no accessibility
permission; screen may be locked). Instead, add a **temporary** XCUITest
harness: a `PantryPilotUITests` target (`bundle.ui-testing`, dependency +
`TEST_TARGET_NAME: PantryPilot`) and a `UIVerify` scheme in `project.yml`,
then `xcodebuild test -scheme UIVerify -destination ...`. Runs headless even
when the Mac is locked. **Revert project.yml and delete the test dir before
committing.**

Gotchas:
- Custom stepper rows use `.accessibilityElement(children: .ignore)` — tap
  their +/- via `coordinate(withNormalizedOffset:)`, assert via `value`.
- Option cards merge title+subtitle into one label — match with
  `label BEGINSWITH` predicates.
- `xcrun simctl uninstall booted com.gurv.PantryPilot` first for a fresh
  SwiftData store.

## Inspecting persisted data

```bash
DATA=$(xcrun simctl get_app_container booted com.gurv.PantryPilot data)
sqlite3 "$DATA/Library/Application Support/default.store" "SELECT ... FROM ZUSERPROFILE;"
# Array columns are NSKeyedArchiver blobs: SELECT writefile('b.bin', ZCOL) then plutil -p b.bin
```

## Dark Mode

`xcrun simctl ui booted appearance dark` is NOT applied by this simulator
runtime (verified: even Settings stays light). Use the app's own theme
preference instead:

```bash
xcrun simctl spawn booted defaults write com.gurv.PantryPilot settings.appearanceMode dark
# relaunch, screenshot, then: defaults delete com.gurv.PantryPilot settings.appearanceMode
```
