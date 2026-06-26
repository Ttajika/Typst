#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

// =============================================================
//  signaling-game : シグナリングゲームの展開形（通称「カニの図」）
//  2タイプ × 2メッセージ × 2行動。手配置の専用ジェネレータ。
//
//   中央=自然 → 上下=タイプ → 送り手(P1)がメッセージ(左右)
//   → 受け手(P2)。受け手はタイプを観察できず、メッセージごとに
//   情報集合（左=m1, 右=m2）を破線で連結。各受け手から行動→利得。
// =============================================================

#let signaling-game(
  // ノード名
  sender: $1$, receiver: $2$,
  nature: box(circle(radius: 2.6pt, fill: black, stroke: none)), // 偶然手番
  // 自然の枝（タイプ）／メッセージ／行動 のラベル
  nat-1: $t_1 (p)$, nat-2: $t_2 (1-p)$,
  msg-1: $m_1$, msg-2: $m_2$,
  act-1: $a$, act-2: $b$,
  // 利得（content, 並びは (送り手, 受け手)）。pay-<type><msg><act>
  pay-11a: $(2,1)$, pay-11b: $(0,0)$, // t1, m1
  pay-12a: $(3,0)$, pay-12b: $(1,2)$, // t1, m2
  pay-21a: $(1,1)$, pay-21b: $(0,2)$, // t2, m1
  pay-22a: $(2,2)$, pay-22b: $(0,1)$, // t2, m2
  // レイアウト
  vtype: 2.0, // 中央から各タイプまでの縦距離
  arm: 3.2, // タイプから受け手までの横距離
  claw: 1.8, // 受け手から利得までの横距離
  claw-spread: 0.8, // 爪（行動枝）の縦の開き
  node-radius: 8pt,
  spacing: (10mm, 10mm),
  edge-stroke: 0.7pt,
  iset-stroke: (thickness: 0.6pt, dash: "dashed"),
  msg-side: left, // メッセージラベルの側（上腕）
) = {
  let pn(b) = box(circle(radius: node-radius, stroke: 0.6pt, inset: 0pt)[#align(center + horizon)[#b]])

  diagram(
    spacing: spacing,
    // 中央：自然
    node((0, 0), nature, name: <N>),
    // 送り手（タイプ別）
    node((0, -vtype), pn(sender), name: <s1>),
    node((0, vtype), pn(sender), name: <s2>),
    // 受け手
    node((-arm, -vtype), pn(receiver), name: <r11>),
    node((arm, -vtype), pn(receiver), name: <r12>),
    node((-arm, vtype), pn(receiver), name: <r21>),
    node((arm, vtype), pn(receiver), name: <r22>),
    // 自然 → タイプ
    edge(<N>, <s1>, nat-1, "-", stroke: edge-stroke, label-side: left),
    edge(<N>, <s2>, nat-2, "-", stroke: edge-stroke, label-side: left),
    // 送り手 → メッセージ
    edge(<s1>, <r11>, msg-1, "-", stroke: edge-stroke, label-side: left),
    edge(<s1>, <r12>, msg-2, "-", stroke: edge-stroke, label-side: right),
    edge(<s2>, <r21>, msg-1, "-", stroke: edge-stroke, label-side: right),
    edge(<s2>, <r22>, msg-2, "-", stroke: edge-stroke, label-side: left),
    // 受け手 → 行動 → 利得（爪）
    edge(<r11>, (-arm - claw, -vtype - claw-spread), act-1, "-", stroke: edge-stroke),
    node((-arm - claw, -vtype - claw-spread), pay-11a),
    edge(<r11>, (-arm - claw, -vtype + claw-spread), act-2, "-", stroke: edge-stroke),
    node((-arm - claw, -vtype + claw-spread), pay-11b),
    edge(<r21>, (-arm - claw, vtype - claw-spread), act-1, "-", stroke: edge-stroke),
    node((-arm - claw, vtype - claw-spread), pay-21a),
    edge(<r21>, (-arm - claw, vtype + claw-spread), act-2, "-", stroke: edge-stroke),
    node((-arm - claw, vtype + claw-spread), pay-21b),
    edge(<r12>, (arm + claw, -vtype - claw-spread), act-1, "-", stroke: edge-stroke),
    node((arm + claw, -vtype - claw-spread), pay-12a),
    edge(<r12>, (arm + claw, -vtype + claw-spread), act-2, "-", stroke: edge-stroke),
    node((arm + claw, -vtype + claw-spread), pay-12b),
    edge(<r22>, (arm + claw, vtype - claw-spread), act-1, "-", stroke: edge-stroke),
    node((arm + claw, vtype - claw-spread), pay-22a),
    edge(<r22>, (arm + claw, vtype + claw-spread), act-2, "-", stroke: edge-stroke),
    node((arm + claw, vtype + claw-spread), pay-22b),
    // 情報集合（受け手はタイプを観察できない）
    edge(<r11>, <r21>, stroke: iset-stroke),
    edge(<r12>, <r22>, stroke: iset-stroke),
  )
}
