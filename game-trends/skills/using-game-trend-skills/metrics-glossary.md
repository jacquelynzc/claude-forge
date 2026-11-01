# Metrics Glossary

Definitions and formulas only. **Benchmark values are deliberately absent.** Look them up live for the specific genre, platform, geo and month (see `sources.md`), and cite them.

## Acquisition
| Term | Definition |
|---|---|
| **CPI** | Cost per install = ad spend / installs. The main "marketability" signal in prototype tests. |
| **CTR** | Clicks / ad impressions. Measures the creative hook. |
| **IPM** | Installs per 1,000 ad impressions. A creative strength signal that doesn't depend on bid price. |
| **CVR** | Store page visitors → installs. Measures store page / ASO quality. |
| **Marketability test** | A short paid campaign on a prototype to measure CPI/CTR/IPM. Publishers often fund it. |
| **UA** | User acquisition (paid). |
| **Organic / K-factor** | Installs without paid ads. K = invites (or shares) per user × conversion per invite. K > 1 means viral growth. |
| **Spark Ads** | TikTok format that boosts an existing organic post as an ad. |
| **Playable ad** | Interactive mini-demo ad. |

## Retention & engagement
| Term | Definition |
|---|---|
| **Dn retention** | Share of an install cohort that opens the game on day n (D0 = install day). Usually D1, D7, D30. |
| **Cohort** | Users who installed on the same day or in the same week. Always compare like-for-like cohorts. |
| **Playtime** | Total seconds played per user on a given day (D0 playtime is a key early signal). |
| **Session length / sessions per DAU** | Average session duration / sessions per daily active user. |
| **DAU / MAU / stickiness** | Daily / monthly actives. Stickiness = DAU / MAU. |
| **FTUE** | First-time user experience, roughly the first 60 seconds to first level. |
| **Level funnel** | % of starters reaching level n. A sharp drop marks a difficulty spike or a confusing mechanic. |

## Monetization
| Term | Definition |
|---|---|
| **IAA / IAP / Hybrid** | In-app ads / in-app purchases / both. |
| **eCPM** | Ad revenue per 1,000 impressions. Varies strongly by format (rewarded > interstitial > banner), geo, OS and season (Q4 is highest). |
| **Impressions per DAU** | Ads shown per daily user, by format. |
| **ARPDAU** | Revenue / DAU for a day. Ad part ≈ Σ over formats (impressions per DAU × eCPM / 1000). |
| **ARPU / ARPPU** | Revenue per user / per paying user. |
| **Payer conversion** | Paying users / active users. |
| **LTV** | Lifetime revenue per install. Rough model: ARPDAU × expected lifetime days, where lifetime days ≈ Σ retention(d) across days. |
| **ROAS (Dn)** | Revenue by day n / ad spend for that cohort. |
| **Payback** | Day when cumulative cohort revenue ≥ spend. |
| **Mediation** | Running several ad networks in an auction (e.g. AppLovin MAX, LevelPlay, AdMob mediation) to raise eCPM. |
| **Fill rate** | Ad requests filled / requests. |
| **D2C / web shop** | Selling IAP outside app stores to avoid store fees. |

## Unit economics rule
A game scales on paid UA only when **LTV > CPI** with margin, measured on real cohorts. Without paid UA, the question becomes whether **organic installs × LTV** covers the time spent.

## Categories
| Term | Meaning |
|---|---|
| **Hyper-casual** | One-mechanic, instant-play, ad-monetized, very short sessions. |
| **Hybrid-casual** | Hyper-casual accessibility + meta layer (progression, collection, decoration) + IAA and IAP. |
| **Casual** | Deeper content games (match-3, merge, etc.), IAP-heavy, LiveOps-driven. |
| **Meta layer** | Systems outside the core loop that give reasons to return: collections, upgrades, rooms, albums, streaks. |
| **LiveOps** | Ongoing events, seasonal content and offers after launch. |
| **Reskin** | Same mechanic, new theme and art. |
