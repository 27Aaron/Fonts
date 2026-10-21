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
| `LXGW WenKai` | en / zh-TW / zh-CN | 80 | Regular |
| `LXGW WenKai Light` | en / zh-TW / zh-CN | 50 | Light |
| `LXGW WenKai Medium` | en / zh-TW / zh-CN | 100 | Medium |

Mono family:

| Family | Language | Weight | Style |
| --- | --- | --- | --- |
| `LXGW WenKai Mono` | en / zh-TW / zh-CN | 80 | Regular |
| `LXGW WenKai Mono Light` | en / zh-TW / zh-CN | 50 | Light |
| `LXGW WenKai Mono Medium` | en / zh-TW / zh-CN | 100 | Medium |

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
| `LXGW WenKai TC` | en / zh-TW / zh-CN | 80 | Regular |
| `LXGW WenKai TC Light` | en / zh-TW / zh-CN | 50 | Light |
| `LXGW WenKai TC Medium` | en / zh-TW / zh-CN | 100 | Medium |

Mono family:

| Family | Language | Weight | Style |
| --- | --- | --- | --- |
| `LXGW WenKai Mono TC` | en / zh-TW / zh-CN | 80 | Regular |
| `LXGW WenKai Mono TC Light` | en / zh-TW / zh-CN | 50 | Light |
| `LXGW WenKai Mono TC Medium` | en / zh-TW / zh-CN | 100 | Medium |

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
<summary><strong>ndot-55</strong> — Ndot-55</summary>

- **Version**: unstable-2025-04-27
- **Styles**: Regular — in both a proportional and a caps-only cut
- **Format**: OpenType (`.otf`), two files
- **Licence**: unfree — Nothing brand material only; the name table forbids sharing and modification
- **Homepage**: https://github.com/xeji01/nothingfont
- **Nix**: [`nix/ndot-55.nix`](nix/ndot-55.nix)

| Family | Language | Weight | Style |
| --- | --- | --- | --- |
| `Ndot 55` | en | 80 | Regular |
| `Ndot55Caps` | en | 80 | Regular |

Upstream publishes no tags or releases, so the package pins the commit that last touched the files and carries a hand-written `unstable-` version. The two cuts register their family names differently — `Ndot 55` with a space, `Ndot55Caps` without — and the caps cut maps the lowercase codepoints onto uppercase glyphs, so text set in it comes out in capitals. It is also the only cut with Cyrillic coverage (ru, uk, bg, sr, be), which the proportional cut lacks.

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
| `PingFang {SC,TC,HK,MO}` | en / zh-TW / zh-CN | 0 | Ultralight |
| `PingFang {SC,TC,HK,MO}` | en / zh-TW / zh-CN | 40 | Thin |
| `PingFang {SC,TC,HK,MO}` | en / zh-TW / zh-CN | 50 | Light |
| `PingFang {SC,TC,HK,MO}` | en / zh-TW / zh-CN | 80 | Regular |
| `PingFang {SC,TC,HK,MO}` | en / zh-TW / zh-CN | 100 | Medium |
| `PingFang {SC,TC,HK,MO}` | en / zh-TW / zh-CN | 180 | Semibold |

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
