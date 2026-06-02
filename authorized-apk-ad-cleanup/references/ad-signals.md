# Ad And Analytics Signals

Use this reference during inventory and patch planning. Treat matches as leads, not proof that code can be removed safely.

## Common Manifest Signals

- Permissions: `AD_ID`, ad SDK custom permissions, broad storage/network/device-id permissions.
- Providers: ad file providers, multi-process providers, downloader providers.
- Activities: splash ads, interstitials, reward video, landing pages, web ad pages.
- Services/receivers: ad downloaders, remote SDK services, analytics collectors.
- Metadata: ad app ids, analytics app keys, channel ids.

## Keyword Seeds

Search manifest, resources, assets, and smali for:

```text
openadsdk
pangolin
TTAd
TTReward
TTFullScreen
TTNative
穿山甲
bytedance
gromore
msdk
gdt
qq.e.ads
kwad
ksad
sigmob
admob
google.android.gms.ads
umeng
友盟
analytics
advert
ad_
广告
开屏
插屏
激励
reward
interstitial
splash
banner
```

For Windows PowerShell, avoid invalid wildcard paths such as `decompiled\smali*` when passed directly to `rg`. Prefer enumerating target roots or searching `decompiled` with file globs:

```powershell
rg -n -i "openadsdk|pangolin|gdt|qq\.e\.ads|kwad|ksad|umeng|advert|广告|reward|interstitial|splash|banner" decompiled --glob "*.xml" --glob "*.smali" --glob "*.json" --glob "*.properties" --glob "*.txt"
```

## Safe Triage Heuristics

- Prefer app-owned caller sites over vendor SDK internals.
- Prefer no-oping ad request paths over deleting classes.
- Preserve callbacks that unblock UI flow.
- Keep network and storage code when it also supports normal content.
- Treat payment, VIP, login, DRM, license, and signature checks as out of scope even when search terms match nearby ad code.

## Evidence To Keep

For each finding worth acting on, record:

- File path and line number.
- Matched signal.
- Why it appears ad/analytics-related.
- Proposed lowest-risk change.
- Whether user-facing functionality could be affected.
