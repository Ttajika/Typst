#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

// =============================================================
//  game-tree : tdtr 風の list/enum 記法を展開形ゲームの木にする
//
//   - 項目 / + 項目        ノード / 直前の枝のラベル（+省略でラベルなし）
//   ノード行のマーカー:
//     #info("tag")         情報集合（同タグを破線連結）
//     #name(content)       参照名（ノード上に小さく添える）
//     #val(content)        伝播値（後ろ向き帰納の解。ノード下に添える）
//     #dim                 淡色化（部分木ごと枝刈り表示）
//     #subgame             この部分木を箱で囲む
//     #mark(key: v, ...)   任意属性（node-render で形状等を出し分け）
//     #cont(action, ...)   連続手番（扇形＋代表枝）。子1つ＝継続 / 子なし＝終端
//                          payoff:, theta:, r:, d:, lo:, hi: を指定可
//   枝行（+）のマーカー:
//     #side("above"|...)   ラベル位置（画面基準）
//     #pick                均衡経路として強調（太線＋色）
//     #dim                 淡色化
// =============================================================

// ---- マーカー -----------------------------------------------
#let info(tag) = metadata((gt-iset: tag))
#let side(s) = metadata((gt-side: s))
#let name(n) = metadata((gt-name: n))
#let val(v) = metadata((gt-val: v))
#let pick = metadata((gt-pick: true))
#let dim = metadata((gt-dim: true))
#let subgame = metadata((gt-sub: true))
#let mark(..a) = metadata((gt-mark: a.named()))
#let cont(action, ..a) = metadata((gt-cont: (action: action, ..a.named())))

// ---- content 内省ヘルパ -------------------------------------
#let _is-li(c) = type(c) == content and c.func() == list.item
#let _is-ei(c) = type(c) == content and c.func() == enum.item
#let _kids(c) = {
  if c == none { () } else if c.has("children") { c.children } else { (c,) }
}
#let _meta(c, key) = c.func() == metadata and type(c.value) == dictionary and key in c.value

#let _split-edge(body) = {
  let lab = []
  let sd = none
  let pk = false
  let dm = false
  for q in _kids(body) {
    if _meta(q, "gt-side") { sd = q.value.at("gt-side") } else if _meta(q, "gt-pick") { pk = true } else if _meta(q, "gt-dim") { dm = true } else if q.func() != parbreak { lab += q }
  }
  (lab, sd, pk, dm)
}

#let _parse(item) = {
  let label = []
  let iset = none
  let nm = none
  let vl = none
  let dm = false
  let sub = false
  let mk = (:)
  let cnt = none
  let seen = false
  let pl = none
  let ps = none
  let pp = false
  let pd = false
  let children = ()
  for p in _kids(item.body) {
    if _is-ei(p) {
      seen = true
      let (lab, sd, pk, ed) = _split-edge(p.body)
      pl = lab
      ps = sd
      pp = pk
      pd = ed
    } else if _is-li(p) {
      seen = true
      children.push((label: pl, side: ps, pick: pp, dim: pd, node: _parse(p)))
      pl = none
      ps = none
      pp = false
      pd = false
    } else if not seen {
      if _meta(p, "gt-iset") { iset = p.value.at("gt-iset") } else if _meta(p, "gt-name") { nm = p.value.at("gt-name") } else if _meta(p, "gt-val") { vl = p.value.at("gt-val") } else if _meta(p, "gt-dim") { dm = true } else if _meta(p, "gt-sub") { sub = true } else if _meta(p, "gt-mark") { mk = p.value.at("gt-mark") } else if _meta(p, "gt-cont") { cnt = p.value.at("gt-cont") } else if p.func() != parbreak { label += p }
    }
  }
  (body: label, children: children, iset: iset, nm: nm, val: vl, dimmed: dm, sub: sub, mark: mk, cont: cnt)
}

#let _roots(c) = {
  if c == none { () } else if _is-li(c) { (c,) } else { _kids(c).filter(_is-li) }
}

// 連続手番のジオメトリを既定値で解決
#let _prep-cont(node, dflt) = {
  let nc = node.children.map(c => (..c, node: _prep-cont(c.node, dflt)))
  let cont = node.cont
  if cont != none {
    cont = (
      action: cont.at("action", default: none),
      payoff: cont.at("payoff", default: none),
      theta: cont.at("theta", default: dflt.theta),
      r: cont.at("r", default: dflt.r),
      d: cont.at("d", default: dflt.d),
      lo: cont.at("lo", default: none),
      hi: cont.at("hi", default: none),
    )
  }
  (..node, cont: cont, children: nc)
}

// 淡色化を部分木に伝播
#let _prop-dim(node, inherited) = {
  let nd = node.dimmed or inherited
  let nc = ()
  for c in node.children {
    let cd = c.dim or nd
    nc.push((..c, dim: cd, node: _prop-dim(c.node, cd)))
  }
  (..node, dimmed: nd, children: nc)
}

// 部分木の x をまとめてずらす
#let _shift(node, dx) = {
  let nc = node.children.map(c => (..c, node: _shift(c.node, dx)))
  (..node, x: node.x + dx, children: nc)
}

// ---- 座標付け -----------------------------------------------
#let _coords(node, depth, next) = {
  if node.cont != none {
    let halfW = node.cont.r * calc.sin(node.cont.theta)
    if node.children.len() == 0 {
      let w = calc.max(1.0, 2 * halfW)
      ((..node, x: next + w / 2, y: depth), next + w)
    } else {
      let succ = node.children.first()
      let (cn0, n2) = _coords(succ.node, depth + 1, next)
      let coff = cn0.x - next
      let leftpad = calc.max(0.0, halfW - coff)
      let cn = if leftpad > 0 { _shift(cn0, leftpad) } else { cn0 }
      let cx = cn.x
      let nextp = calc.max(n2 + leftpad, cx + halfW)
      ((..node, x: cx, y: depth, children: ((..succ, node: cn),)), nextp)
    }
  } else {
    let ch = node.children
    if ch.len() == 0 {
      ((..node, x: next * 1.0, y: depth), next + 1)
    } else {
      let acc = ()
      let nx = next
      for c in ch {
        let (cn, nx2) = _coords(c.node, depth + 1, nx)
        acc.push((..c, node: cn))
        nx = nx2
      }
      let xs = acc.map(c => c.node.x)
      ((..node, children: acc, x: (xs.first() + xs.last()) / 2, y: depth), nx)
    }
  }
}

#let _pos(x, y, dir) = {
  if dir == "down" { (x, y) } else if dir == "up" { (x, -y) } else if dir == "right" { (y, x) } else if dir == "left" { (-y, x) } else { (x, y) }
}
#let _growth(dir) = if dir == "down" { (0, 1) } else if dir == "up" { (0, -1) } else if dir == "right" { (1, 0) } else if dir == "left" { (-1, 0) } else { (0, 1) }

// 任意の stroke を退色（paint の不透明度のみ下げ、太さ・破線・色相は保持）
#let _fade(s, amount) = {
  let st = stroke(s)
  let p = if st.paint == auto { black } else { st.paint }
  let d = (paint: p.transparentize(amount))
  if st.thickness != auto { d.insert("thickness", st.thickness) }
  if st.dash != none { d.insert("dash", st.dash) }
  if st.cap != auto { d.insert("cap", st.cap) }
  if st.join != auto { d.insert("join", st.join) }
  d
}

#let _resolve-side(s, dir) = {
  if s == none { return none }
  if s == "on" or s == "center" { return center }
  let horiz = dir == "right" or dir == "left"
  if horiz {
    if dir == "right" {
      if s == "above" { return left }
      if s == "below" { return right }
    } else {
      if s == "above" { return right }
      if s == "below" { return left }
    }
    none
  } else {
    if dir == "down" {
      if s == "left" { return right }
      if s == "right" { return left }
    } else {
      if s == "left" { return left }
      if s == "right" { return right }
    }
    none
  }
}

#let _flatten(node, dir, acc) = {
  let id = acc.next
  acc.nodes.push((
    id: id,
    pos: _pos(node.x, node.y, dir),
    body: node.body,
    leaf: node.children.len() == 0 and node.cont == none,
    iset: node.iset,
    nm: node.nm,
    val: node.val,
    dimmed: node.dimmed,
    sub: node.sub,
    mark: node.mark,
    cont: node.cont,
    x: node.x,
  ))
  acc.next = id + 1
  for c in node.children {
    let cid = acc.next
    acc = _flatten(c.node, dir, acc)
    if node.cont == none {
      acc.edges.push((from: id, to: cid, label: c.label, side: c.side, pick: c.pick, dim: c.dim))
    }
  }
  if node.cont != none {
    acc.conts.push((id: id, succ: node.children.len() > 0, cont: node.cont))
  }
  acc.ranges.insert(str(id), acc.next - 1)
  acc
}

// ---- 公開関数 -----------------------------------------------
#let game-tree(
  it,
  dir: "down",
  level-sep: 16mm,
  sibling-sep: 16mm,
  node-render: n => n.body,
  edge-marks: "-",
  edge-stroke: 0.7pt,
  label-pos: 0.5,
  label-sep: 2pt,
  label-side: none,
  name-gap: 1.1em,
  name-size: 0.8em,
  name-fill: gray.darken(70%),
  val-gap: 0.9em,
  val-size: 0.85em,
  val-fill: rgb("#0b7285"),
  pick-stroke: 1.7pt + rgb("#1971c2"),
  dim-amount: 70%,
  subgame-stroke: (paint: rgb("#868e96"), dash: "dashed", thickness: 0.7pt),
  subgame-radius: 3pt,
  subgame-inset: 7pt,
  subgame-fill: none,
  // 連続手番（扇形）
  cont-theta: 38deg,
  cont-r: 0.7,
  cont-d: 1.15,
  cont-sector-stroke: 0.6pt + luma(55%),
  cont-branch-stroke: 0.8pt,
  cont-action-pos: 0.5,
  cont-segments: 16,
  ..rest,
) = {
  let roots = _roots(it)
  assert(roots.len() > 0, message: "game-tree: '-' で始まるノードが見つかりません")
  let t0 = _prep-cont(_parse(roots.first()), (theta: cont-theta, r: cont-r, d: cont-d))
  let t1 = _prop-dim(t0, false)
  let (tree, _) = _coords(t1, 0, 0)
  let acc = _flatten(tree, dir, (nodes: (), edges: (), conts: (), ranges: (:), next: 0))

  let spacing = if dir == "down" or dir == "up" { (sibling-sep, level-sep) } else { (level-sep, sibling-sep) }

  // 部分ゲームの箱
  let boxes = ()
  for n in acc.nodes {
    if n.sub {
      let last = acc.ranges.at(str(n.id))
      let ids = range(n.id, last + 1)
      boxes.push(node(enclose: ids.map(i => label("gt-" + str(i))), stroke: subgame-stroke, corner-radius: subgame-radius, inset: subgame-inset, fill: subgame-fill))
    }
  }

  // ノード
  let render-node(n) = {
    let base = node-render(n)
    if n.dimmed { base = text(fill: black.transparentize(dim-amount), base) }
    box({
      base
      if n.nm != none { place(top + center, dy: -name-gap, text(name-size, fill: name-fill, n.nm)) }
      if n.val != none { place(bottom + center, dy: val-gap, text(val-size, fill: val-fill, n.val)) }
    })
  }
  let nodes = acc.nodes.map(n => node(n.pos, render-node(n), name: label("gt-" + str(n.id))))

  // 枝
  let edges = acc.edges.map(e => {
    let pa = (label("gt-" + str(e.from)), label("gt-" + str(e.to)))
    let lab = e.label
    if lab != none and e.dim { lab = text(fill: black.transparentize(dim-amount), lab) }
    if lab != none { pa.push(lab) }
    if edge-marks != none { pa.push(edge-marks) }
    let st = edge-stroke
    if e.pick { st = pick-stroke }
    if e.dim { st = _fade(st, dim-amount) }
    let named = (stroke: st, label-pos: label-pos, label-sep: label-sep)
    let sd = _resolve-side(if e.side != none { e.side } else { label-side }, dir)
    if sd != none { named.insert("label-side", sd) }
    edge(..pa, ..named)
  })

  // 連続手番（扇形＋代表枝）
  let posof = (:)
  for n in acc.nodes { posof.insert(str(n.id), n.pos) }
  let g = _growth(dir)
  let cont-elems = ()
  for c in acc.conts {
    let (ax, ay) = posof.at(str(c.id))
    let (gx, gy) = g
    let r = c.cont.r
    let th = c.cont.theta
    let rot(a) = (gx * calc.cos(a) - gy * calc.sin(a), gx * calc.sin(a) + gy * calc.cos(a))
    let pt(rr, a) = { let (ux, uy) = rot(a); (ax + rr * ux, ay + rr * uy) }
    cont-elems.push(edge((ax, ay), pt(r, -th), stroke: cont-sector-stroke))
    cont-elems.push(edge((ax, ay), pt(r, th), stroke: cont-sector-stroke))
    let prev = pt(r, -th)
    for i in range(1, cont-segments + 1) {
      let a = -th + (i / cont-segments) * 2 * th
      let cur = pt(r, a)
      cont-elems.push(edge(prev, cur, stroke: cont-sector-stroke))
      prev = cur
    }
    let aname = label("gt-" + str(c.id))
    if c.succ {
      cont-elems.push(edge(aname, label("gt-" + str(c.id + 1)), c.cont.action, "-", stroke: cont-branch-stroke, label-pos: cont-action-pos, label-sep: 3pt))
    } else {
      let pp = (ax + gx * c.cont.d, ay + gy * c.cont.d)
      let pname = label("gt-cp-" + str(c.id))
      cont-elems.push(node(pp, c.cont.payoff, name: pname))
      cont-elems.push(edge(aname, pname, c.cont.action, "-", stroke: cont-branch-stroke, label-pos: cont-action-pos, label-sep: 3pt))
    }
    if c.cont.lo != none { cont-elems.push(node(pt(r * 1.08, th), text(0.78em, c.cont.lo))) }
    if c.cont.hi != none { cont-elems.push(node(pt(r * 1.08, -th), text(0.78em, c.cont.hi))) }
  }

  // 情報集合
  let groups = (:)
  for n in acc.nodes {
    if n.iset != none {
      let k = str(n.iset)
      groups.insert(k, groups.at(k, default: ()) + (n,))
    }
  }
  let iset-edges = ()
  for (_, members) in groups {
    if members.len() >= 2 {
      let s = members.sorted(key: m => m.x)
      for i in range(s.len() - 1) {
        iset-edges.push(edge(label("gt-" + str(s.at(i).id)), label("gt-" + str(s.at(i + 1).id)), stroke: (thickness: 0.6pt, dash: "dashed")))
      }
    }
  }

  diagram(spacing: spacing, ..rest, ..boxes, ..nodes, ..edges, ..cont-elems, ..iset-edges)
}
