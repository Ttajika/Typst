#import "game-tree.typ": game-tree, info, side, name, val, pick, dim, subgame, mark, cont
#set page(paper: "a4", margin: 16mm)
#set text(font: ("Noto Serif CJK JP",), size: 9.5pt, lang: "ja")
#show raw.where(block: true): set text(size: 8pt)

#align(center, text(15pt, weight: "bold")[game-tree : list 記法 → 展開形ゲームの木])
#v(2mm)

*記法* — `-` ノード / `+` 直前の枝のラベル（省略でラベルなし）。マーカー:
#set list(spacing: 0.5em)
- ノード行: `#name(c)` 参照名 / `#val(c)` 伝播値 / `#dim` 淡色化（部分木へ伝播）/ `#subgame` 箱で囲む / `#mark(key: v)` 任意属性（`node-render` で参照）/ `#info("t")` 情報集合
- 枝行(`+`): `#side("above"/"below"/"left"/"right"/"on")` ラベル位置 / `#pick` 均衡経路の強調 / `#dim` 淡色化

#let g1 = [
- $1$
  + $L$
  - $2$
    + $ell$
    - $(3,1)$
//    + $r$
    - $(0,0)$
  + $R$
  - $(1,1)$
]
#grid(columns: 3, column-gutter: 6mm,
  align(center)[`dir:"down"` \ #game-tree(dir: "down", g1)],
  align(center)[`dir:"right"` \ #game-tree(dir: "right", g1)],
  align(center)[`#side` で上下調整 \ #game-tree(dir: "right")[
- $1$
  + $L$ #side("above")
  - $2$
    + $ell$ #side("above")
    - $(3,1)$
    + $r$ #side("below")
    - $(0,0)$
  + $R$ #side("below")
  - $(1,1)$
]],
)

#v(3mm)
#line(length: 100%, stroke: 0.3pt + gray)
#v(2mm)

*バックワードインダクション・キット* — 名前・伝播値・均衡経路・枝刈り・部分ゲーム。
`node-render` は `n.dimmed` を見て淡色時の枠色も変える。

#grid(columns: (1.15fr, 1fr), column-gutter: 6mm, align: horizon,
```typ
#let dnode(n) = if n.leaf { n.body } else {
  box(circle(radius: 9pt, inset: 0pt,
    stroke: if n.dimmed { 0.6pt + gray }
            else { 0.6pt })[
    #align(center+horizon)[#n.body]])
}
#game-tree(node-render: dnode)[
- $1$ #name($x_0$) #val($(2,1)$)
  + In #pick
  - $2$ #name($x_1$) #val($(2,1)$) #subgame
    + Fight #dim
    - $(-1,-1)$
    + Acc #pick
    - $(2,1)$
  + Out
  - $(0,2)$
]
```,
  {
    let dnode(n) = if n.leaf { n.body } else {
      box(circle(radius: 9pt, inset: 0pt, stroke: if n.dimmed { 0.6pt + gray } else { 0.6pt })[#align(center + horizon)[#n.body]])
    }
    align(center, game-tree(
      dir: "down", level-sep: 18mm, sibling-sep: 20mm, node-render: dnode,
    )[
- $1$ #name($x_0$) #val($(2,1)$)
  + $"In"$ #pick
  - $2$ #name($x_1$) #val($(2,1)$) #subgame
    + $"Fight"$ #dim
    - $(-1,-1)$
    + $"Acc"$ #pick
    - $(2,1)$
  + $"Out"$
  - $(0,2)$
])
  },
)

#v(3mm)
#line(length: 100%, stroke: 0.3pt + gray)
#v(2mm)

*情報集合と per-node 形状* — `#info` で破線連結。`#mark` ＋ `node-render` で偶然手番を四角に。

#grid(columns: 2, column-gutter: 8mm, align: horizon,
  {
    let cn(n) = if n.leaf { n.body } else { box(circle(radius: 9pt, stroke: 0.6pt, inset: 0pt)[#align(center + horizon)[#n.body]]) }
    align(center, game-tree(dir: "down", level-sep: 16mm, sibling-sep: 14mm, node-render: cn)[
- $1$
  + $L$
  - $2$ #info("a")
    + $ell$
    - $(3,1)$
    + $r$
    - $(0,0)$
  + $R$
  - $2$ #info("a")
    + $ell$
    - $(2,2)$
    + $r$
    - $(1,4)$
])
  },
  {
    let nr(n) = {
      if n.leaf { n.body } else if n.mark.at("shape", default: "circle") == "square" { box(rect(stroke: 0.6pt, inset: 4pt, n.body)) } else { box(circle(radius: 9pt, stroke: 0.6pt, inset: 0pt)[#align(center + horizon)[#n.body]]) }
    }
    align(center, game-tree(dir: "down", level-sep: 16mm, sibling-sep: 16mm, node-render: nr)[
- $1$
  + $"In"$
  - $N$ #mark(shape: "square")
    + $1\/2$
    - $(1,1)$
    + $1\/2$
    - $(0,0)$
  + $"Out"$
  - $(2,2)$
])
  },
)

#v(3mm)
#line(length: 100%, stroke: 0.3pt + gray)
#v(2mm)

*連続行動（扇形）* — `#cont(q)`。子1つで継続（代表枝が後続へ）、子なしで終端（`payoff:`）。

#let cn(n) = if n.leaf { n.body } else { box(circle(radius: 9pt, stroke: 0.6pt, inset: 0pt)[#align(center + horizon)[#n.body]]) }
#grid(columns: 2, column-gutter: 10mm, align: horizon,
  align(center)[継続 \ #v(1mm) #game-tree(node-render: cn, level-sep: 18mm, sibling-sep: 16mm)[
- $1$ #cont($q$)
  - $2$
    + $H$
    - $(3,1)$
    + $L$
    - $(1,2)$
]],
  align(center)[終端 \ #v(1mm) #game-tree(node-render: cn, level-sep: 18mm)[
- $1$ #cont($q$, payoff: $u_1(q)$, lo: $0$, hi: $infinity$)
]],
)
