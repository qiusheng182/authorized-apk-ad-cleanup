# Authorized APK Ad Cleanup

**Authorized APK Ad Cleanup** is a Codex/Claude skill for carefully maintaining Android APKs when you own the app or have explicit permission to modify it.

It is designed for a practical, real-world workflow: inspect a decompiled APK, identify ad and analytics surfaces, apply minimal ad-cleanup patches, rebuild and sign the APK, then verify the result on a real device with ADB. The final step is especially important: the skill does not stop at "the app launches." It helps discover the app's user-facing functions and checks that those flows still work.

> This skill is for authorized maintenance only. It is not for bypassing VIP, paid content, subscriptions, login, DRM, licensing, payment flows, or signature checks.

## What This Skill Helps You Do

- Ask a simple authorization question before any APK modification.
- Summarize the current APK workspace and choose the next workflow phase automatically.
- Inspect `AndroidManifest.xml`, `apktool.yml`, `res/`, `assets/`, `lib/`, and `smali*` directories.
- Find likely ad and analytics signals such as OpenADSDK/Pangolin, GDT, KWAD, Umeng, banners, splash ads, interstitials, and reward ads.
- Keep changes scoped and reversible instead of deleting broad SDK folders blindly.
- Rebuild and sign modified APKs with local tools such as apktool and uber-apk-signer.
- Use ADB to install, launch, capture screenshots, dump UI XML, collect logcat, and verify behavior.
- Identify user-facing app functions and run ADB-based regression checks so normal features remain usable.

## Why It Is Useful

APK cleanup work can get messy fast. A single over-broad smali edit can remove an ad and break the reader page, search screen, settings panel, or startup flow.

This skill gives Claude or Codex a staged operating procedure:

1. Confirm authorization.
2. Understand the workspace.
3. Inventory ad, analytics, core app, and protected-access surfaces.
4. Patch the smallest safe target.
5. Rebuild and sign.
6. Verify launch behavior with ADB.
7. Discover real user functions.
8. Regression-test those functions with ADB evidence.
9. Report what changed, what passed, and what remains risky.

The result is a cleaner maintenance loop with fewer broken builds, fewer forgotten verification steps, and a clearer record of what was actually tested.

## Install For Codex

### Windows PowerShell

```powershell
$repo = Join-Path $env:TEMP "authorized-apk-ad-cleanup"
Remove-Item -Recurse -Force $repo -ErrorAction SilentlyContinue
git clone https://github.com/qiusheng182/authorized-apk-ad-cleanup.git $repo
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.codex\skills" | Out-Null
Copy-Item -Recurse -Force "$repo\authorized-apk-ad-cleanup" "$env:USERPROFILE\.codex\skills\"
```

### macOS/Linux

```bash
repo="$(mktemp -d)/authorized-apk-ad-cleanup"
git clone https://github.com/qiusheng182/authorized-apk-ad-cleanup.git "$repo"
mkdir -p "$HOME/.codex/skills"
cp -R "$repo/authorized-apk-ad-cleanup" "$HOME/.codex/skills/"
```

Then start a new Codex session and invoke:

```text
Use $authorized-apk-ad-cleanup to inspect my authorized APK cleanup workflow.
```

## Install For Claude

### Windows PowerShell

```powershell
$repo = Join-Path $env:TEMP "authorized-apk-ad-cleanup"
Remove-Item -Recurse -Force $repo -ErrorAction SilentlyContinue
git clone https://github.com/qiusheng182/authorized-apk-ad-cleanup.git $repo
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\skills" | Out-Null
Copy-Item -Recurse -Force "$repo\authorized-apk-ad-cleanup" "$env:USERPROFILE\.claude\skills\"
```

### macOS/Linux

```bash
repo="$(mktemp -d)/authorized-apk-ad-cleanup"
git clone https://github.com/qiusheng182/authorized-apk-ad-cleanup.git "$repo"
mkdir -p "$HOME/.claude/skills"
cp -R "$repo/authorized-apk-ad-cleanup" "$HOME/.claude/skills/"
```

Then start a new Claude Code session and invoke:

```text
Use $authorized-apk-ad-cleanup to inspect my authorized APK cleanup workflow.
```

## Install For Both Claude And Codex

After cloning the repository, you can also run the included installer.

### Windows PowerShell

```powershell
git clone https://github.com/qiusheng182/authorized-apk-ad-cleanup.git
cd authorized-apk-ad-cleanup
.\install.ps1 -Target both
```

### macOS/Linux

```bash
git clone https://github.com/qiusheng182/authorized-apk-ad-cleanup.git
cd authorized-apk-ad-cleanup
chmod +x install.sh
./install.sh both
```

## Example Prompts

```text
Use $authorized-apk-ad-cleanup to inspect this APK workspace and tell me which phase should run next.
```

```text
Use $authorized-apk-ad-cleanup to rebuild and ADB-verify my authorized no-ad APK.
```

```text
Use $authorized-apk-ad-cleanup to identify user-facing functions in this APK and verify them with ADB.
```

## Repository Layout

```text
authorized-apk-ad-cleanup/
  SKILL.md
  agents/
    openai.yaml
  references/
    ad-signals.md
    adb-functional-regression.md
install.ps1
install.sh
README.md
LICENSE
```

## Safety Boundary

This project intentionally draws a bright line:

- In scope: authorized ad cleanup, privacy/analytics inventory, rebuild/signing, and regression verification.
- Out of scope: bypassing paid features, VIP membership, subscriptions, login, DRM, licensing, payment flows, signature checks, or other access controls.

That boundary keeps the workflow useful for legitimate maintenance while protecting users, developers, and downstream agents from turning a cleanup task into unauthorized circumvention.

## License

MIT
