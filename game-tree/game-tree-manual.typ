#import "game-tree.typ": game-tree, info, side, name, val, pick, dim, subgame, mark, cont
#import "selten-horse.typ": selten-horse
#import "signaling-game.typ": signaling-game

// ===== ドキュメント設定 =====
#set page(
  paper: "a4",
  margin: (x: 20mm, y: 22mm),
  numbering: "1",
  footer: context [
    #set text(8pt, fill: luma(40%))
    #line(length: 100%, stroke: 0.3pt + luma(70%))
    #v(-2mm)
    game-tree マニュアル #h(1fr) #counter(page).display("1")
  ],
)
#set text(font: ("Noto Serif CJK JP",), size: 10pt, lang: "ja")
#set par(justify: true, leading: 0.7em)
#show raw.where(block: true): set text(size: 8pt)
#show raw.where(block: false): set text(size: 9pt)
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => { v(2mm); block(text(13pt, weight: "bold", it)); v(1mm) }
#show heading.where(level: 2): it => block(text(11pt, weight: "bold", it))

// ===== 例示ヘルパ（同一ソースを表示＆実行）=====
#let circled(n) = if n.leaf { n.body } else {
  box(circle(radius: 9pt, inset: 0pt, stroke: if n.dimmed { 0.6pt + gray } else { 0.6pt })[#align(center + horizon)[#n.body]])
}
#let withsquare(n) = if n.leaf { n.body } else if n.mark.at("shape", default: "circle") == "square" {
  box(rect(stroke: 0.6pt, inset: 4pt, n.body))
} else { circled(n) }

#let SC = (
  game-tree: game-tree, selten-horse: selten-horse,
  signaling-game: signaling-game,
  info: info, side: side, name: name, val: val,
  pick: pick, dim: dim, subgame: subgame, mark: mark,
  cont: cont,
  circled: circled, withsquare: withsquare,
)

#let ex(r, col: false) = {
  let out = align(center + horizon, eval(r.text, mode: "markup", scope: SC))
  let inner = if col { stack(spacing: 4mm, r, align(center, out)) } else {
    grid(columns: (1fr, 1fr), column-gutter: 6mm, align: horizon, r, out)
  }
  block(width: 100%, stroke: 0.4pt + luma(75%), radius: 4pt, inset: 8pt, breakable: false, inner)
}

#let kbd(s) = raw(s)

// ===== 表紙 =====
#align(center)[
  #v(12mm)
  #text(24pt, weight: "bold")[game-tree]
  #v(2mm)
  #text(13pt)[list 記法でつくる展開形ゲームの木 — Typst + fletcher]
  #v(3mm)
  #text(10pt, fill: luma(40%))[ユーザーマニュアル]
]
#v(8mm)

#block(stroke: 0.4pt + luma(70%), radius: 4pt, inset: 10pt, width: 100%)[
  *概要.* 箇条書き（`-`）と番号付き（`+`）の Typst マークアップで木を書くと、それを
  展開形ゲームのゲームの木として描画します。手番ノード・利得・枝ラベル・情報集合に加え、
  バックワードインダクションの説明に使う均衡経路の強調・伝播値・枝刈り・部分ゲームの囲み、
  偶然手番などのノード形状の出し分けに対応します。縦横の向きも切り替えられます。
  典型的なゼルテンの馬は、情報集合が木の深さをまたぐため、座標手配置の専用関数
  `selten-horse` を別に用意しています。シグナリングゲームの展開形（カニの図）も
  `signaling-game` として用意しています。
]

#outline(title: [目次], depth: 1, indent: auto)

#pagebreak()

= 準備

二つのファイルを同じ場所に置き、必要な関数をインポートします。

#ex(```typ
#import "game-tree.typ": game-tree, info, side, name, val, pick, dim, subgame, mark, cont
#import "selten-horse.typ": selten-horse
#import "signaling-game.typ": signaling-game
```, col: true)

依存パッケージは `fletcher`（内部で `cetz`）で、通常の Typst 環境なら初回コンパイル時に
自動取得されます。日本語を含める場合は CJK フォント（例: Noto Serif CJK JP）を
`#set text(font: ...)` で指定してください。本マニュアルの図はすべて、左の実ソースを
`eval` で実行した結果です。

= 基本の記法

`-` で始まる項目が *ノード*（手番プレイヤー名、または終端の利得）、その直下に
インデントした `+` 項目が *直前の枝のラベル*になります。`+` の直後の `-` がその枝の
行き先（子ノード）です。`+` を省略（またはコメントアウト）すると、ラベルなしの枝になります。

#ex(```typ
#game-tree[
- $1$
  + $L$
  - $2$
    + $ell$
    - $(3,1)$
//    + $r$   ← コメントアウトでラベルなし
    - $(0,0)$
  + $R$
  - $(1,1)$
]
```)

ノードの中身は任意の content です（数式 `$...$`、文字列、画像など）。根は一つを想定し、
トップレベルの最初の `-` 項目を根とみなします。

= 向きとサイズ

`dir` で向きを選びます（`"down"` 縦・根が上 / `"up"` / `"right"` 横・根が左 / `"left"`）。
`level-sep` が階層方向、`sibling-sep` が兄弟方向の間隔です。

#ex(```typ
#game-tree(dir: "right", level-sep: 14mm, sibling-sep: 12mm)[
- $1$
  + $L$
  - $2$
    + $ell$
    - $(3,1)$
    + $r$
    - $(0,0)$
  + $R$
  - $(1,1)$
]
```)

= ノードの描画 (`node-render`)

`node-render` は各ノードのレコード `n` を受け取り、描画する content を返すフックです。
既定は `n => n.body`（中身をそのまま表示）。`n` のフィールドは次のとおり。

#table(
  columns: (auto, 1fr),
  inset: 5pt,
  align: (left, left),
  stroke: 0.4pt + luma(75%),
  table.header([*フィールド*], [*内容*]),
  [`n.body`], [ノードの表示内容（`-` に書いた中身）],
  [`n.leaf`], [葉（終端）なら `true`],
  [`n.dimmed`], [淡色化対象なら `true`（`#dim` とその伝播）],
  [`n.nm`], [`#name(...)` の内容、なければ `none`],
  [`n.val`], [`#val(...)` の内容、なければ `none`],
  [`n.sub`], [`#subgame` 指定なら `true`],
  [`n.iset`], [`#info(...)` のタグ、なければ `none`],
  [`n.mark`], [`#mark(...)` で与えた辞書（既定 `(:)`）],
  [`n.pos`], [fletcher 上の座標 `(col, row)`],
  [`n.id`, `n.x`], [内部ID / 論理 spread 座標],
)

たとえば手番ノードを丸で囲み、淡色時は枠色を変える描画は次のように書けます
（このマニュアルでは `circled` として定義し、以降の例で使います）。

#ex(```typ
#let circled(n) = if n.leaf { n.body } else {
  box(circle(radius: 9pt, inset: 0pt,
    stroke: if n.dimmed { 0.6pt + gray } else { 0.6pt })[
    #align(center + horizon)[#n.body]])
}
#game-tree(node-render: circled)[
- $1$
  + $L$
  - $2$
    + $ell$
    - $(3,1)$
    + $r$
    - $(0,0)$
  + $R$
  - $(1,1)$
]
```)

= 枝ラベルの位置 (`#side`)

枝行（`+`）に `#side("...")` を付けると、その枝のラベル位置を画面基準で指定できます。
横置きでバランスが悪いとき、枝ごとに上下へ振り分けられます。値と向きの対応は次の表のとおり
（"–" は枝に沿う方向になるため無効で、既定位置にフォールバックします）。

#table(
  columns: (auto, auto, auto, auto, auto, auto),
  inset: 5pt, align: center, stroke: 0.4pt + luma(75%),
  table.header([*dir*], [`"above"`], [`"below"`], [`"left"`], [`"right"`], [`"on"`]),
  [`down`/`up`], [–], [–], [左], [右], [枝上],
  [`right`/`left`], [上], [下], [–], [–], [枝上],
)

#ex(```typ
#game-tree(dir: "right")[
- $1$
  + $L$ #side("above")
  - $2$
    + $ell$ #side("above")
    - $(3,1)$
    + $r$ #side("below")
    - $(0,0)$
  + $R$ #side("below")
  - $(1,1)$
]
```)

全枝の既定の側は関数引数 `label-side`（例 `label-side: "above"`）でも指定でき、
各枝の `#side` がそれを上書きします。

= 情報集合 (`#info`)

ノード行に `#info("タグ")` を付けると、同じタグのノード同士を破線で連結します
（プレイヤーがそれらを区別できない、という標準的な表現）。3個以上は鎖状につなぎます。

#ex(```typ
#game-tree(node-render: circled)[
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
]
```, col: true)

破線の見た目は `iset-stroke` で変更できます。なお情報集合が木の深さをまたぐ場合
（ゼルテンの馬など）は、自動レイアウトでは段がそろわないため、後述の `selten-horse` か
座標手配置を使ってください。

= バックワードインダクション・キット

後ろ向き帰納の説明に使う三つのマーカーです。

#table(
  columns: (auto, auto, 1fr),
  inset: 5pt, align: (left, center, left), stroke: 0.4pt + luma(75%),
  table.header([*マーカー*], [*行*], [*効果*]),
  [`#pick`], [`+`], [その枝を均衡経路として強調（太線＋色 `pick-stroke`）],
  [`#val(c)`], [`-`], [後ろ向き帰納で確定する値をノード下に表示],
  [`#dim`], [`+` / `-`], [淡色化。枝に付けると *その部分木ごと* グレーになる（枝刈り）],
)

参入阻止ゲームの例。SPE は (In, Accommodate)。`In`・`Acc` を強調し、`Fight` 枝を枝刈り、
各ノードに参照名と伝播値を添えています。`node-render` は `n.dimmed` を見て淡色時の枠色も
変えます。

#ex(```typ
#game-tree(
  node-render: circled,
  level-sep: 20mm, sibling-sep: 22mm,
)[
- $1$ #name($x_0$) #val($(2,1)$)
  + In #pick
  - $2$ #name($x_1$) #val($(2,1)$)
    + Fight #dim
    - $(-1,-1)$
    + Acc #pick
    - $(2,1)$
  + Out
  - $(0,2)$
]
```, col: true)

色や位置は `pick-stroke`、`val-fill` / `val-gap`、`dim-fill` / `dim-stroke` で調整できます。

= 部分ゲーム (`#subgame`)

ノード行に `#subgame` を付けると、その部分木全体を箱で囲みます（fletcher の `enclose`）。

#ex(```typ
#game-tree(node-render: circled, sibling-sep: 20mm)[
- $1$
  + In #pick
  - $2$ #subgame
    + Fight #dim
    - $(-1,-1)$
    + Acc #pick
    - $(2,1)$
  + Out
  - $(0,2)$
]
```, col: true)

箱の見た目は `subgame-stroke` / `subgame-radius` / `subgame-inset` / `subgame-fill`。

= ノードごとの属性と形状 (`#mark`)

`#mark(key: 値, ...)` でノードに任意の属性を持たせ、`node-render` の中で `n.mark` を見て
描画を出し分けられます。偶然手番（自然）を四角で描く例（確率は枝ラベルにそのまま書きます）。

#ex(```typ
#let withsquare(n) = {
  if n.leaf { n.body }
  else if n.mark.at("shape", default: "circle") == "square" {
    box(rect(stroke: 0.6pt, inset: 4pt, n.body))
  } else { circled(n) }
}
#game-tree(node-render: withsquare)[
- $1$
  + In
  - $N$ #mark(shape: "square")
    + $1\/2$
    - $(1,1)$
    + $1\/2$
    - $(0,0)$
  + Out
  - $(2,2)$
]
```, col: true)

= 連続行動（扇形） (`#cont`)

連続的な行動集合（価格・数量・努力など）は、ノード行に `#cont(行動ラベル, ...)` を付けて
*扇形*で表します。扇形は手番ノードを中心とする円弧セクター（円弧は手番から外向き）で、
そこから代表的な選択肢が枝 1 本だけ伸びます。

子が 1 つあれば *継続*（代表枝がその後続ノードへ）、子がなければ *終端*（代表枝が利得へ。
`payoff:` で指定）になります。

#ex(```typ
// 継続: 1 が連続的な q を選び、2 が観測して H/L で応じる
#game-tree(node-render: circled, level-sep: 18mm)[
- $1$ #cont($q$)
  - $2$
    + $H$
    - $(3,1)$
    + $L$
    - $(1,2)$
]
```, col: true)

#ex(```typ
// 終端: 連続行動 → 連続体の利得。上下限ラベルは lo:/hi:
#game-tree(node-render: circled, level-sep: 18mm)[
- $1$ #cont($q$, payoff: $u_1(q)$, lo: $0$, hi: $infinity$)
]
```, col: true)

`#cont` のオプションは `payoff`（終端の利得）、`theta`（開き角）、`r`（半径）、`d`（終端で
利得までの距離）、`lo`/`hi`（両端のラベル）。全体の既定は関数引数 `cont-theta` / `cont-r` /
`cont-d`、線は `cont-sector-stroke`（扇形）/ `cont-branch-stroke`（代表枝）で変えられます。
扇形は `level-sep` と `sibling-sep` がほぼ等しい前提で正円になります（既定は等しい）。

= マーカー早見表

#table(
  columns: (auto, auto, 1fr),
  inset: 5pt, align: (left, center, left), stroke: 0.4pt + luma(75%),
  table.header([*マーカー*], [*行*], [*効果*]),
  [`#name(c)`], [`-`], [参照名をノード上に小さく表示],
  [`#val(c)`], [`-`], [伝播値をノード下に表示],
  [`#dim`], [`-` / `+`], [淡色化（枝に付けると部分木へ伝播）],
  [`#subgame`], [`-`], [部分木を箱で囲む],
  [`#mark(k: v)`], [`-`], [任意属性を `n.mark` に載せる],
  [`#info("t")`], [`-`], [同タグを破線で連結（情報集合）],
  [`#side("...")`], [`+`], [ラベル位置（画面基準）],
  [`#pick`], [`+`], [均衡経路として強調],
  [`#cont(a, ..)`], [`-`], [連続行動の扇形＋代表枝（子1つ=継続/子なし=終端）],
)
一行に複数併用できます（例 `- $2$ #name($x_1$) #val($(2,1)$) #subgame`）。

= `game-tree` パラメータ早見表

#table(
  columns: (auto, auto, 1fr),
  inset: 5pt, align: (left, left, left), stroke: 0.4pt + luma(75%),
  table.header([*引数*], [*既定*], [*意味*]),
  [`dir`], [`"down"`], [向き: down/up/right/left],
  [`level-sep`], [`16mm`], [階層方向の間隔],
  [`sibling-sep`], [`16mm`], [兄弟方向の間隔],
  [`node-render`], [`n => n.body`], [ノードの描画関数],
  [`edge-marks`], [`"-"`], [枝の矢じり（`none` で直線）],
  [`edge-stroke`], [`0.7pt`], [枝の線],
  [`label-pos`], [`0.5`], [枝ラベルの位置（0〜1）],
  [`label-sep`], [`2pt`], [枝とラベルの距離],
  [`label-side`], [`none`], [全枝の既定の側（画面基準）],
  [`name-gap` / `-size` / `-fill`], [`1.1em` / `0.8em` / `gray`], [`#name` の位置・大きさ・色],
  [`val-gap` / `-size` / `-fill`], [`0.9em` / `0.85em` / 〔teal〕], [`#val` の位置・大きさ・色],
  [`pick-stroke`], [〔1.7pt 青〕], [`#pick` の強調線],
  [`dim-fill` / `dim-stroke`], [〔gray〕], [`#dim` の文字色 / 線],
  [`subgame-stroke`], [〔gray 破線〕], [`#subgame` の枠線],
  [`subgame-radius` / `-inset` / `-fill`], [`3pt` / `7pt` / `none`], [枠の角丸・余白・塗り],
  [`iset-stroke`], [〔0.6pt 破線〕], [情報集合の破線],
  [`cont-theta` / `cont-r` / `cont-d`], [`38deg` / `0.7` / `1.15`], [扇形の開き角 / 半径 / 終端距離],
  [`cont-sector-stroke` / `cont-branch-stroke`], [〔gray〕 / `0.8pt`], [扇形の線 / 代表枝の線],
)
これら以外の引数（`spacing` を除く）は内部の `diagram` にそのまま渡ります。

#pagebreak()

= `selten-horse`

ゼルテンの馬専用の座標手配置ジェネレータです。情報集合が木の深さをまたぐため、
2つのプレイヤー3ノードを同じ高さに置き、標準的な図にします。

#ex(```typ
#selten-horse()
```, col: true)

構造は、プレイヤー1が $C$/$D$、$C$ なら2が $c$/$d$、1の $D$ と2の $c$ がそれぞれ
プレイヤー3の情報集合の2ノードに入り、3はそこで $L$/$R$。ラベル・利得・向きを差し替えた例:

#ex(```typ
#selten-horse(
  dir: "down",
  a-C: $C$, a-D: $D$, b-c: $c$, b-d: $d$, c-L: $ell$, c-R: $r$,
  pay-DL: $(1,1,1)$, pay-DR: $(3,3,0)$,
  pay-d: $(2,2,2)$, pay-cL: $(0,0,0)$, pay-cR: $(4,4,1)$,
)
```, col: true)

#table(
  columns: (auto, auto, 1fr),
  inset: 5pt, align: (left, left, left), stroke: 0.4pt + luma(75%),
  table.header([*引数*], [*既定*], [*意味*]),
  [`a-C` / `a-D`], [`$C$` / `$D$`], [プレイヤー1の行動ラベル],
  [`b-c` / `b-d`], [`$c$` / `$d$`], [プレイヤー2の行動ラベル],
  [`c-L` / `c-R`], [`$L$` / `$R$`], [プレイヤー3の行動ラベル],
  [`pay-DL` `pay-DR`], [`$(1,1,1)$` `$(3,3,0)$`], [1:D 後、3が L / R の利得],
  [`pay-d`], [`$(0,0,0)$`], [2:d の利得],
  [`pay-cL` `pay-cR`], [`$(4,4,0)$` `$(2,2,2)$`], [1:C,2:c 後、3が L / R の利得],
  [`p1` / `p2` / `p3`], [`$1$` / `$2$` / `$3$`], [手番ノードに入れる名],
  [`dir`], [`"down"`], [向き],
  [`level-sep` / `sibling-sep`], [`16mm` / `14mm`], [間隔],
  [`node-radius`], [`7pt`], [手番ノードの丸の半径],
  [`edge-stroke` / `iset-stroke`], [`0.7pt` / 〔破線〕], [枝 / 情報集合の線],
)
利得の既定値は一例です。

= `signaling-game`

シグナリングゲームの展開形（通称「カニの図」）を描く専用ジェネレータです。
2 タイプ × 2 メッセージ × 2 行動。中央の自然がタイプを選び、送り手 (1) が観察して
メッセージ、受け手 (2) はタイプを観察できず、メッセージごとに情報集合（左 = `msg-1`、
右 = `msg-2`）が破線で連結されます。

#ex(```typ
#signaling-game()
```, col: true)

ラベル・確率・利得を差し替えた例（就職市場シグナリング風）:

#ex(```typ
#signaling-game(
  sender:[学],
  receiver:[企],
  nature:[自然],
  nat-1: [高能力 $(p)$], nat-2: [低能力 $(1-p)$],
  msg-1: [進学], msg-2: [進学せず],
  act-1: [採用], act-2: [不採用],
)
```, col: true)

#table(
  columns: (auto, auto, 1fr),
  inset: 5pt, align: (left, left, left), stroke: 0.4pt + luma(75%),
  table.header([*引数*], [*既定*], [*意味*]),
  [`sender` / `receiver`], [`$1$` / `$2$`], [送り手 / 受け手の名],
  [`nature`], [〔黒丸〕], [偶然手番ノードの見た目],
  [`nat-1` / `nat-2`], [`$t_1(p)$` / `$t_2(1-p)$`], [自然の枝（タイプ・確率）],
  [`msg-1` / `msg-2`], [`$m_1$` / `$m_2$`], [メッセージのラベル],
  [`act-1` / `act-2`], [`$a$` / `$b$`], [受け手の行動ラベル],
  [`pay-11a` … `pay-22b`], [〔一例〕], [8 つの終端利得 (送り手, 受け手)。],
  [`vtype` / `arm` / `claw` / `claw-spread`], [`2.0` / `3.2` / `1.8` / `0.8`], [配置の距離],
  [`node-radius` / `spacing`], [`8pt` / `(10mm,10mm)`], [ノード半径 / 間隔],
  [`edge-stroke` / `iset-stroke`], [`0.7pt` / 〔破線〕], [枝 / 情報集合の線],
)

= ギャラリー

複数機能を組み合わせた例をまとめます。

== 手番交代の3段ゲーム（経路強調＋値）

#ex(```typ
#game-tree(node-render: circled, sibling-sep: 14mm, level-sep: 16mm)[
- $1$ #name($x_0$) #val($(3,2)$)
  + $T$ #pick
  - $2$ #name($x_1$) #val($(3,2)$)
    + $ell$ #pick
    - $3$ #val($(3,2)$)
      + $u$ #pick
      - $(3,2)$
      + $d$ #dim
      - $(0,0)$
    + $r$ #dim
    - $(1,1)$
  + $B$ #dim
  - $(2,3)$
]
```, col: true)

== 情報集合つき同時手番（部分ゲームの箱）

#ex(```typ
#game-tree(node-render: circled, sibling-sep: 18mm)[
- $1$ #subgame
  + $A$ 
  - $2$ #info("h") 
    + $L$
    - $(2,2)$
    + $R$
    - $(0,3)$
  + $B$
  - $2$ #info("h")
    + $L$
    - $(3,0)$
    + $R$
    - $(1,1)$
]
```, col: true)

== 連続行動の二段ゲーム（シュタッケルベルク型）

#ex(```typ
#game-tree(node-render: circled, level-sep: 20mm, sibling-sep: 18mm)[
- $1$ #cont($q_1$)
  - $2$ #cont($q_2$, payoff: $(pi_1, pi_2)$)
]
```, col: true)

= メモと制約

- 根は一つだけ想定です（トップレベルの最初の `-` を根とみなします）。
- `#dim` はノードのテキスト色をグレーにします。`node-render` で図形（丸など）を描く場合は、
  例の `circled` のように `n.dimmed` を見て枠色を変えてください。
- 横置きで `"above"`/`"below"`、縦置きで `"left"`/`"right"` のように軸に合わない `#side` は
  無効化され、既定位置になります。
- `edge-marks` に `none` を渡すと矢じりなしの直線になります（内部で `marks` 引数を省略）。
- 情報集合が木の深さをまたぐ図は自動レイアウトでは段がそろいません。ゼルテンの馬は
  `selten-horse`、その他は座標手配置の関数化（拡張）で対応できます。
- `#cont` の後続は 1 つだけ（代表ノード）です。扇形は `level-sep` ≈ `sibling-sep` のとき
  正円になり、両者が大きく違うと楕円に見えます。
