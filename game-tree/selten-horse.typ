#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

// =============================================================
//  selten-horse : ゼルテンの馬（3人, 1つの情報集合をまたぐ）
//  手配置レイアウトの専用ジェネレータ
//
//   P1: C → P2 / D → 3の左ノード
//   P2: c → 3の右ノード / d → 終端
//   P3: 情報集合 {左, 右} で L / R
// =============================================================

#let _pos(x, y, dir) = {
  if dir == "down" { (x, y) } else if dir == "up" { (x, -y) } else if dir == "right" { (y, x) } else if dir == "left" { (-y, x) } else { (x, y) }
}

#let selten-horse(
  // 行動ラベル
  a-C: $C$, a-D: $D$, // プレイヤー1
  b-c: $c$, b-d: $d$, // プレイヤー2
  c-L: $L$, c-R: $R$, // プレイヤー3
  // 利得（content。順序は (1,2,3)）※下記は一例、編集可
  pay-DL: $(1,1,1)$, // 1:D, 3:L
  pay-DR: $(3,3,0)$, // 1:D, 3:R
  pay-d: $(0,0,0)$, // 2:d
  pay-cL: $(4,4,0)$, // 1:C 2:c, 3:L
  pay-cR: $(2,2,2)$, // 1:C 2:c, 3:R
  // 手番ノードに入れるプレイヤー名
  p1: $1$, p2: $2$, p3: $3$,
  dir: "down",
  level-sep: 16mm,
  sibling-sep: 14mm,
  node-radius: 7pt,
  edge-stroke: 0.7pt,
  iset-stroke: (thickness: 0.6pt, dash: "dashed"),
  ..rest,
) = {
  let P(x, y) = _pos(x, y, dir)
  let spacing = if dir == "down" or dir == "up" { (sibling-sep, level-sep) } else { (level-sep, sibling-sep) }
  // 手番ノード（プレイヤー番号を丸囲み）
  let dn(lbl) = box(circle(radius: node-radius, stroke: 0.6pt, inset: 0pt)[#align(center + horizon)[#text(0.95em, lbl)]])

  diagram(
    spacing: spacing,
    ..rest,
    // 手番ノード
    node(P(2, 0), dn(p1), name: <n1>),
    node(P(6, 1), dn(p2), name: <n2>),
    node(P(1, 3), dn(p3), name: <n3l>),
    node(P(6, 3), dn(p3), name: <n3r>),
    // 終端（利得）
    node(P(0, 4.3), pay-DL, name: <tdl>),
    node(P(2, 4.3), pay-DR, name: <tdr>),
    node(P(8, 2.2), pay-d, name: <td>),
    node(P(5, 4.3), pay-cL, name: <tcl>),
    node(P(7, 4.3), pay-cR, name: <tcr>),
    // 枝
    edge(<n1>, <n2>, a-C, "-", stroke: edge-stroke),
    edge(<n1>, <n3l>, a-D, "-", stroke: edge-stroke),
    edge(<n2>, <n3r>, b-c, "-", stroke: edge-stroke),
    edge(<n2>, <td>, b-d, "-", stroke: edge-stroke),
    edge(<n3l>, <tdl>, c-L, "-", stroke: edge-stroke),
    edge(<n3l>, <tdr>, c-R, "-", stroke: edge-stroke),
    edge(<n3r>, <tcl>, c-L, "-", stroke: edge-stroke),
    edge(<n3r>, <tcr>, c-R, "-", stroke: edge-stroke),
    // 情報集合（破線）
    edge(<n3l>, <n3r>, stroke: iset-stroke),
  )
}
