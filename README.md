## Fonts

My everyday fonts, packaged as a Nix flake.

<details>
<summary><strong>dank-mono</strong> — Dank Mono</summary>

- **Version**: 1.000
- **Styles**: Bold, Italic, Regular
- **Format**: OpenType (`.otf`)
- **Licence**: unfree
- **Nix**: [`nix/dank-mono.nix`](nix/dank-mono.nix)

| Family | Language | Weight | Style |
| --- | --- | --- | --- |
| `Dank Mono` | en | 200 | Bold |
| `Dank Mono` | en | 80 | Italic |
| `Dank Mono` | en | 80 | Regular |

</details>
<details>
<summary><strong>lxgw-wenkai</strong> — LXGW WenKai (霞鹜文楷)</summary>

- **Version**: 1.530
- **Styles**: Light, Regular, Medium — in both proportional and Mono
- **Format**: TrueType (`.ttf`)
- **Licence**: OFL-1.1
- **Homepage**: https://github.com/lxgw/LxgwWenKai
- **Nix**: [`nix/lxgw-wenkai.nix`](nix/lxgw-wenkai.nix)

Proportional family:

| Family | Language | Weight | Style |
| --- | --- | --- | --- |
| `LXGW WenKai` | en | 80 | Regular |
| `霞鶩文楷` | zh-TW | 80 | Regular |
| `霞鹜文楷` | zh-CN | 80 | Regular |
| `LXGW WenKai Light` | en | 50 | Light |
| `霞鶩文楷 Light` | zh-TW | 50 | Light |
| `霞鹜文楷 Light` | zh-CN | 50 | Light |
| `LXGW WenKai Medium` | en | 100 | Medium |
| `霞鶩文楷 Medium` | zh-TW | 100 | Medium |
| `霞鹜文楷 Medium` | zh-CN | 100 | Medium |

Mono family:

| Family | Language | Weight | Style |
| --- | --- | --- | --- |
| `LXGW WenKai Mono` | en | 80 | Regular |
| `霞鶩文楷等寬` | zh-TW | 80 | Regular |
| `霞鹜文楷等宽` | zh-CN | 80 | Regular |
| `LXGW WenKai Mono Light` | en | 50 | Light |
| `霞鶩文楷等寬 Light` | zh-TW | 50 | Light |
| `霞鹜文楷等宽 Light` | zh-CN | 50 | Light |
| `LXGW WenKai Mono Medium` | en | 100 | Medium |
| `霞鶩文楷等寬 Medium` | zh-TW | 100 | Medium |
| `霞鹜文楷等宽 Medium` | zh-CN | 100 | Medium |

There is no Bold weight; a bold request falls back to Medium.

</details>
<details>
<summary><strong>lxgw-wenkai-tc</strong> — LXGW WenKai TC (霞鹜文楷 TC)</summary>

- **Version**: 1.530
- **Styles**: Light, Regular, Medium — in both proportional and Mono
- **Format**: TrueType (`.ttf`)
- **Licence**: OFL-1.1
- **Homepage**: https://github.com/lxgw/LxgwWenKaiTC
- **Nix**: [`nix/lxgw-wenkai-tc.nix`](nix/lxgw-wenkai-tc.nix)

Proportional family:

| Family | Language | Weight | Style |
| --- | --- | --- | --- |
| `LXGW WenKai TC` | en | 80 | Regular |
| `霞鶩文楷 TC` | zh-TW | 80 | Regular |
| `霞鹜文楷 TC` | zh-CN | 80 | Regular |
| `LXGW WenKai TC Light` | en | 50 | Light |
| `霞鶩文楷 TC Light` | zh-TW | 50 | Light |
| `霞鹜文楷 TC Light` | zh-CN | 50 | Light |
| `LXGW WenKai TC Medium` | en | 100 | Medium |
| `霞鶩文楷 TC Medium` | zh-TW | 100 | Medium |
| `霞鹜文楷 TC Medium` | zh-CN | 100 | Medium |

Mono family:

| Family | Language | Weight | Style |
| --- | --- | --- | --- |
| `LXGW WenKai Mono TC` | en | 80 | Regular |
| `霞鶩文楷等寬 TC` | zh-TW | 80 | Regular |
| `霞鹜文楷等宽 TC` | zh-CN | 80 | Regular |
| `LXGW WenKai Mono TC Light` | en | 50 | Light |
| `霞鶩文楷等寬 TC Light` | zh-TW | 50 | Light |
| `霞鹜文楷等宽 TC Light` | zh-CN | 50 | Light |
| `LXGW WenKai Mono TC Medium` | en | 100 | Medium |
| `霞鶩文楷等寬 TC Medium` | zh-TW | 100 | Medium |
| `霞鹜文楷等宽 TC Medium` | zh-CN | 100 | Medium |

There is no Bold weight; a bold request falls back to Medium.

</details>
<details>
<summary><strong>monolisa</strong> — MonoLisa</summary>

- **Version**: 2.015
- **Styles**: Light, Regular, Medium, SemiBold, Bold — with italics
- **Format**: TrueType (`.ttf`)
- **Licence**: unfree
- **Homepage**: https://www.monolisa.dev
- **Nix**: [`nix/monolisa.nix`](nix/monolisa.nix)

| Family | Language | Weight | Style |
| --- | --- | --- | --- |
| `MonoLisa` | en | 80 | Regular |
| `MonoLisa` | en | 80 | Italic |
| `MonoLisa Light` | en | 50 | Light |
| `MonoLisa Light` | en | 50 | Light Italic |
| `MonoLisa Medium` | en | 100 | Medium |
| `MonoLisa Medium` | en | 100 | Medium Italic |
| `MonoLisa SemiBold` | en | 180 | SemiBold |
| `MonoLisa SemiBold` | en | 180 | SemiBold Italic |
| `MonoLisa` | en | 200 | Bold |
| `MonoLisa` | en | 200 | Bold Italic |

</details>
<details>
<summary><strong>pingfang</strong> — PingFang (苹方)</summary>

- **Version**: 21.0d1e1
- **Styles**: Ultralight, Thin, Light, Regular, Medium, Semibold
- **Format**: TrueType Collection (`.ttc`), 24 faces in one file — four regional families in six weights
- **Licence**: unfree
- **Nix**: [`nix/pingfang.nix`](nix/pingfang.nix)

Regional families: `PingFang SC` (苹方-简), `PingFang TC` (苹方-繁), `PingFang HK` (苹方-港), `PingFang MO` (苹方-澳).

| Family | Language | Weight | Style |
| --- | --- | --- | --- |
| `PingFang {SC,TC,HK,MO}` | en / zh-TW / zh-CN | 0 | Ultralight / 极细体 |
| `PingFang {SC,TC,HK,MO}` | en / zh-TW / zh-CN | 40 | Thin / 纤细体 |
| `PingFang {SC,TC,HK,MO}` | en / zh-TW / zh-CN | 50 | Light / 细体 |
| `PingFang {SC,TC,HK,MO}` | en / zh-TW / zh-CN | 80 | Regular / 常规体 |
| `PingFang {SC,TC,HK,MO}` | en / zh-TW / zh-CN | 100 | Medium / 中黑体 |
| `PingFang {SC,TC,HK,MO}` | en / zh-TW / zh-CN | 180 | Semibold / 中粗体 |

</details>
<details>
<summary><strong>zpix</strong> — Zpix (最像素)</summary>

- **Version**: 3.3.0
- **Styles**: Regular
- **Format**: TrueType (`.ttf`)
- **Licence**: unfree — free for personal and educational use; commercial use requires a paid licence
- **Homepage**: https://github.com/SolidZORO/zpix-pixel-font
- **Nix**: [`nix/zpix.nix`](nix/zpix.nix)

| Family | Language | Weight | Style |
| --- | --- | --- | --- |
| `Zpix` | en | 100 | Regular |

</details>
