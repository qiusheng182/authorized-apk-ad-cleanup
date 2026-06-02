---
name: authorized-apk-ad-cleanup
description: Authorized Android APK ad cleanup, privacy/analytics inventory, rebuild/signing, and ADB-based regression verification. Use when the user asks to remove ads, clean ad SDK traces, maintain a decompiled APK, rebuild/sign an APK, inspect ad-related Android components, or verify a modified APK on a device, but only for user-owned or explicitly authorized APKs and never for bypassing VIP, paid content, login, DRM, licensing, or signature checks.
---

# Authorized APK Ad Cleanup

## Mandatory Authorization Gate

Before doing any APK modification, ask one simple question in the user's language:

> 这个 APK 是你自己的，或你已获得明确授权进行去广告/维护修改吗？

Proceed only if the user clearly confirms ownership or authorization.

Stop and provide only compliance-oriented guidance if the answer is unclear, negative, or the requested goal involves bypassing VIP, paid content, login, DRM, licensing, subscriptions, payment flows, signature checks, or other access controls.

## Operating Rules

- Keep the goal limited to authorized ad cleanup, privacy/analytics risk reduction, maintenance, rebuild/signing, and regression verification.
- Prefer minimal, reversible changes over broad SDK deletion.
- Preserve user-facing app functionality as a first-class success criterion.
- Do not remove payment, membership, licensing, login, DRM, or signature-verification logic.
- Record evidence for each build and device-verification pass in an output folder such as `dist/`.
- Work with the existing project layout and local tools before introducing new ones.

## Workspace Decision Tree

Start by summarizing the current workspace:

- APK inputs: `*.apk`, original APK copies, package/version from `apktool.yml` or `AndroidManifest.xml`.
- Decompiled tree: `decompiled/`, `smali*`, `res/`, `assets/`, `lib/`, `unknown/`.
- Tools: `apktool.jar`, `uber-apk-signer.jar`, `adb.exe` or platform-tools.
- Outputs: signed/unsigned APKs, signature logs, install logs, launch logs, screenshots, `uiautomator` XML, logcat.

Choose the next phase automatically:

- If no decompiled tree exists, decompile the authorized input APK.
- If a decompiled tree exists, inventory manifest, resources, assets, libraries, and smali.
- If previous signed APKs and logs exist, resume from build or verification rather than restarting.
- If the app crashes or a user feature fails, use logcat and UI evidence to return to the smallest relevant patch.

## Phase 1: Inventory

Inspect:

- `apktool.yml` for source APK name, version, SDK levels, compression rules.
- `AndroidManifest.xml` for permissions, providers, activities, services, receivers, metadata.
- `res/` for ad containers, splash screens, layouts, drawables, strings, and network config.
- `assets/` for default content, source rules, remote config, embedded databases, or ad text.
- `smali*` for ad SDK initialization, ad loading, callbacks, splash/interstitial/reward flows, and analytics setup.

For ad and analytics signals, consult `references/ad-signals.md`.

## Phase 2: Classify Risk

Classify findings before editing:

- Ad-related: ad SDKs, splash ads, interstitials, banners, reward ads, ad file providers.
- Analytics/privacy-related: tracking SDKs, device identifiers, analytics upload paths.
- App-core: reading/search/navigation/storage/network code required by normal users.
- Protected access: payment, membership, VIP, login, DRM, license, signature checks.

Only the first two categories are in scope. Mark protected access findings as out of scope and leave them untouched.

## Phase 3: Patch Strategy

Apply the lowest-risk change that satisfies the authorized goal:

1. Disable or hide ad UI containers and default ad configuration.
2. Disable app-owned calls into ad-loading entry points.
3. Make ad callbacks fail closed without blocking normal app flow.
4. Remove unnecessary ad permissions or manifest components only when the app still builds and launches.
5. Avoid deleting entire SDK directories unless the dependency graph is understood and verified.

After each meaningful patch, rebuild and verify rather than stacking many unknown changes.

## Phase 4: Rebuild And Sign

Use the local toolchain when present:

- Build with apktool.
- Sign with the available signer, such as `uber-apk-signer.jar`.
- Save unsigned APKs, signed APKs, signature verification logs, and timestamps under `dist/`.
- Keep filenames descriptive, for example `app_no_ads_v2v3_signed.apk` or `app_readfix_signed.apk`.

## Phase 5: Install And Launch Verification

When ADB is available:

- Capture `adb devices`.
- Install the signed APK.
- Launch the detected main activity or known launch activity.
- Capture logcat, screenshot, process id, and `uiautomator dump`.
- Check for crashes, ANRs, white screens, blocking permission dialogs, stuck splash screens, and missing primary UI.

## Phase 6: User Function Discovery And ADB Regression

After the app launches, identify the user-facing functions and verify them with ADB. This is mandatory before final delivery.

Use `uiautomator dump`, screenshots, manifest activities, visible tabs, buttons, menus, text fields, and navigation labels to infer the app's real user functions. Examples include home, bookshelf, search, categories, reader page, settings, profile, import/export, source switching, cache/download, and about/help.

For each key function:

- Navigate using `adb shell input tap`, `text`, `keyevent`, and `swipe`.
- Save a screenshot, window XML, and focused logcat slice.
- Confirm the function opens, responds to input, and does not crash or block.
- If a flow requires network/account/private data, verify the reachable UI path and record the untested dependency.

Use `references/adb-functional-regression.md` for a compact verification pattern and result table.

## Phase 7: Delivery

Report:

- Authorization status.
- Workspace summary.
- APK/package/version.
- Changes made and out-of-scope areas left untouched.
- Final APK path.
- Build/signature verification result.
- Install/launch verification result.
- User-function regression table with evidence files.
- Known residual risks or flows not fully tested.
