// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
//定理の設定

#let trans = (
 en: (Proposition: "Proposition",
      Theorem: "Theorem",
      Table: "Table",
      Figure: "Figure",
      Assumption: "Assumption",
      Definition: "Definition",
      Corollary: "Corollary",
      Lemma: "Lemma",
      Remark: "Remark",
      Example: "Example",
      Claim: "Claim",
      Fact: "Fact",
      Proof: "Proof" 
    ),
jp: (Proposition: "命題",
      Theorem: "定理",
      Table: "表",
      Figure: "図",
     　Assumption: "仮定",
      Definition: "定義",
      Corollary: "系",
      Lemma: "補題",
      Remark: "注意",
      Example: "例",
      Claim: "主張",
      Fact: "事実",
    　Proof:"証明")
)

#let plurals_dic = ("Proposition": "Propositions", "Theorem":"Theorems", "Lemma":"Lemmata", "Definition":"Definitions", "Table":"Tables", "Assumption":"Assumptions", "Figure":"Figures", "Example": "Examples", "Fact":"Facts", "Claim":"Claims")

#let proofname(name,lang) ={
  if lang == "en" {return "Proof of "+ name + "."}
  if lang == "jp" {return name + "の証明."}
}

#let QERmark(lang) ={
  if lang == "en" {return $qed$}
  if lang == "jp" {return [(証了)]}
}

#let counter_body(num) = {if num != none {return num.counter}
else {return num}}

#let cap_body(it) = {if it != none {return it.body}
else {return it}
}

#let my_thm_style(
  thm-type, name, number, body
) = {
  context{
    
 align(left, block(width:100%, breakable: true, spacing: par.leading, stroke:1pt, inset:5pt)[
  #strong(thm-type)
  #if number != none {
    strong(number)
  }#if name  == none {"."}#if name != none {
    " "+ [(#name).] + " "
  }
  #body
])
[#hide[dummy]]
v(-1em)
v(-par.leading)
}}



#let my_defi_style(
  thm-type, name, number, body
) = {
  align(left, block(width:100%, breakable: true,  above:0em, below:0em)[
  #strong(thm-type) 
  #if number != none {
    strong(number) 
  }#if name == none {"."}
  #if name != none {[(#name).] 
  }
  #body]) 
  indent()
}



#let my_proof_style(
  thm-type, name, number, body, lang
) =  {
  align(left, block(width:100%, breakable: true)[
  #if name  == none {strong(trans.at(lang).at("Proof")) +"."}
  #if name != none {
  [#strong[#proofname(name,lang)]] 
  }
    #body  #h(1fr) #QERmark(lang)
  ])
}


#let theorem_base(thm_style, kind, supplement) ={
  return{ (name:none, numbering:numbering,content) =>  figure(
    content,
    caption: name,
    kind: kind,
    supplement: supplement,
  ) 
  }
}


#let trans_thm(str,lang) = {
  if lang == "jp"  {
    return theorem_jp.at(str)
  }
  else {return str}
}

#let theorem_create(tlabel, supple:none) = {
    if supple == none{
    return{theorem_base(my_thm_style, tlabel, tlabel)}
    } else {
    return{theorem_base(my_thm_style, tlabel, supple)}
    }
    
  }

#let theorem = theorem_create("Theorem", supple: "定理")
#let prop = theorem_create("Proposition", supple: "命題")
#let lemma = theorem_create("Lemma", supple: "補題")
#let rem = theorem_create("Remark", supple: "注意")
#let cor = theorem_create("Corollary")
#let claim = theorem_create("Claim")
#let fact = theorem_create("Fact")
#let defi = theorem_create("Definition")
#let assump = theorem_create("Assumption")
#let ex = theorem_create("Example")
#let proof = theorem_create("Proof", supple: "系")



#let theo_list = ("Theorem","Proposition","Lemma","Remark","Corollary","Claim","Fact")
#let defi_list = ("Definition","Assumption","Example")
#let others_list = ("Table","Figure")

#let line_col = blue.lighten(70%)

#let kagi = tiling(size: (1cm, 10pt))[
  #place(dx:0pt,line(start: (0%, 70%), end: (100%, 70%),stroke:1pt+line_col), )
  #place(dx:0pt,line(start: (97%,70%), end: (97%, 100%),stroke:1pt+line_col))
]+10pt

#let notepad = {[#v(-15pt)
  #set text(size:10pt)
  #grid(columns:(1fr,1fr,1fr),[],[#text(fill:line_col)[--- Notes ---]],[#v(-.5cm)#text(fill:line_col,size:0.6em)[Date: #h(.8cm) #math.dot.c #h(.8cm)#math.dot.c]])
  #set text(fill:line_col)
  #set par(leading: 1em)
  #line(length:100%, stroke:line_col)
  #v(1em)
  #line(length:100%, stroke:kagi)
  #for i in range(28){
  [#box(width: 100%, repeat[.]) \ ]
  
}
#v(1em)
  #line(length:100%, stroke:kagi)]}

#let setting-mode(mode) = {if mode == true {
  return (margin: (outside:1.5cm, inside:52%, top:1.5cm,bottom:1cm), background:[#grid(columns:(50%,50%),
          inset:1.5cm,
          rows:1fr,
          [#context[#{ if calc.odd(counter(page).get().at(0)) {notepad}}]  
          ],
          [#context[#{ if calc.even(counter(page).get().at(0)) {notepad}}]]
          )
        ],
         paper:"a4" )} else {
        return ( margin: (left:1.5cm, right:1.5cm,top:1.5cm,bottom:1cm), background:[], paper:"a5")
        }
 } 

#let project(
  title: "",
  title_notes: none,
  abstract: none,
  short-title:"",
  authors: (),
  institutions: (),
  mode: false,
  notes: (),
  font-size: 11pt,
  date: datetime.today().display(),
  body,
  leading:1.0em
) = {
  // Set the document's basic properties.

  set document(author: authors, title: title)
  set page(numbering: "1",
      number-align: center, 
      margin: setting-mode(mode).at("margin"),
      paper: setting-mode(mode).at("paper"), 
      flipped: mode,
      header:box(
        stroke:(bottom:.3pt+gray),
        inset:3pt,
        text(fill:gray)[#short-title #h(1fr)更新日: #datetime.today().display("[year]年[month]月[day]日")]
        ),
      background:
        [ #setting-mode(mode).at("background")
        ]
    )
if mode {set page(numbering:"1", paper: "a4",margin:(top:1.5cm,bottom:1cm) )}

  // Save heading and body font families in variables.
  let body-font = ("Libertinus Serif","Harano Aji Mincho")
  let sans-font = ("Noto Sans Gothic","Harano Aji Gothic")
  let math-font = ("Euler Math","Harano Aji Mincho")
  show regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]"): set text(size: 0.925em)
  set text(font: body-font, lang: "ja", size:font-size)
  show heading: set text(font: sans-font)
  set heading(numbering: "1.1.", supplement: [Section])
  // Set body font family.
  let Maketitle = [#{
  set footnote(numbering: "*")
  // Title row.
  align(center)[
    #set text(font: sans-font, weight: 700, 1.55em)
    #title
    #if title_notes !=none {footnote[#title_notes]}
    #v(.5em, weak: true)
    #set text(font: body-font, weight: 400, 0.5em)
   // #date
  ]
  // Author information.
  let author_note = authors.zip(notes)
  pad(
    top: 0.5em,
    bottom: 0.5em,
    x: 2em,
    grid(
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..author_note.map(author => align(center, [#text(author.at(0))#footnote[#author.at(1)]])),
      ..institutions.map(institutions => align(center, text(institutions)))
    ),
  )
}]

  // Main body. 基本設定.
  // footnoteの設定

  set footnote(numbering: "1")
  counter(footnote).update(0)
  // paragraphの設定． indent 1em, 行送り1.2em
  set par(justify: true, first-line-indent: (amount:1em, all:true), leading:leading,spacing:1.2*leading)
  // fontの設定
  set text(font:body-font, size:font-size)
  
  set text(cjk-latin-spacing: auto)
  
  set math.mat(delim: "[")


  show strong: set text(font: sans-font)
  //数式フォントの設定
  show math.equation: set text(font: math-font)

  //show math.op: set text(font:"New Computer Modern" )

  set math.equation(numbering: "(1)")
  show math.equation.where(block: true): it => {
   let eqbox(eq) = context{
        let par-h = par.spacing
        box(eq,outset:par-h/2, width:100%)}
  if it.has("label")  {
      let tlabel = it.at("label")
     context{
        let  eql = counter("auto-numbering-eq" + str(tlabel))
        if eql.final().at(0) == 1{
          eqbox(it) 
          }
        else {
          counter(math.equation).update(n => n - 1)
          eqbox($display(it.body)$)
        }
      }
    
  }
  else {counter(math.equation).update(n => n - 1)
        eqbox($display(it.body)$)}
}  

  //定理環境その他の設定
  show figure: it => {
  let c_eq = counter_body(it)
  let thenumber = numbering(
      it.numbering,
      ..c_eq.at(it.location()))
  if it.kind in theo_list{
  let name = cap_body(it.caption)
  my_thm_style(trans.at("jp").at(it.kind), name, thenumber, it.body)
  }
  else if it.kind in defi_list{
  let name = cap_body(it.caption)
  my_defi_style(trans.at("jp").at(it.kind), name, thenumber, it.body)
  }
  else if it.kind == "Proof" {
    let name = cap_body(it.caption)
    my_proof_style(trans.at("jp").at(it.kind), name, it.numbering, it.body,lang)}
  else {it}
} 

  show ref:it => {
  let lbl = it.target
  let eq = math.equation
  let el = it.element
  let eql = counter("auto-numbering-eq"+str(lbl))
    eql.update(1)
  if el != none and el.func() == eq {
    // Override equation references.
    [ ] + numbering(
      el.numbering,
      ..counter(eq).at(el.location())
    ) + [ 式 #h(-.25em)] 
  } else {
    // Other references as usual.
    it
  }}
  //items with numberingの設定
  set enum(numbering: "1.a.")
  //引用形式の設定
  //set cite(brackets: true)
  if abstract != none {
    heading(outlined: false, numbering: none, text(0.85em, smallcaps[Abstract]))
  abstract}

  Maketitle + body
  
}








#let inactive_versions(name_varsion) = {
    let name_version(title: none, label:none, body) = {
        }
}



#let aeq(tlabel, body) ={
        locate(loc =>{
        let  eql = counter("auto-numbering-eq" + str(tlabel))
        if eql.final(loc).at(0) == 1{
          [#math.equation(numbering:"(1)",block: true)[#body]
         #label(str(tlabel))]
          }
        else {
         [#math.equation(numbering:none,block: true)[#body] ]
        }
      })
}

#let aref(label) ={
  let eql = counter("auto-numbering-eq"+str(lbl))
  eql.update(1)
  ref(label)
}

#show ref: it => {
  let lbl = it.target
  let eq = math.equation
  let el = it.element
  let eql = counter("auto-numbering-eq"+str(lbl))
    eql.update(1)
  if el != none and el.func() == eq {
    // Override equation references.
    numbering(
      el.numbering,
      ..counter(eq).at(el.location())
    ) 
  } else {
    // Other references as usual.
    it
  }}

  
  #let kadai(body) = {
    let a = counter("kadai")
    a.step()

    block(heading(level:2,numbering: none)[課題 #context[#a.get().at(0)].]+ body,above:1em,below:1em)
  }
  #let namiline = (thickness:.6pt,paint:red.darken(20%),cap:"butt",join:"round")

  #let nami = tiling(size: (2pt, 4pt))[
  #place(dx:0pt,line(start: (0%, 0%), end: (55%, 45%),stroke:namiline), )
  #place(dx:0pt,line(start: (45%, 45%), end: (100%, 0%),stroke:namiline))
]+3.9pt

  #let jemph(it) = {
    underline(stroke:nami,it,offset: 1.0pt)
    
  }

#let vc(x) = $accent(#x,->)$

#let sgn = $op("sgn")$


#let facts(body,title:[],proof:[]) = {
//linebreak()
  block(stroke:1pt, inset:10pt, radius: 5pt, width:100%)[
  #if title !=[] {place(dy:-1.5em,align(center)[#box(stroke:1pt,inset:.5em,fill:white)[#title]])
  v(0.5em) }
  #body
#if proof != [] {[\ #box(line(length:100%)) *(証明)*
]}
#proof
]}

#let npeq(eq) = {
   linebreak()
   let eqbox(eq) = context{
        let par-h = par.spacing
        box(math.equation(block:true,$eq$),//outset:par-h, 
        inset:par-h/2,width:100%)}
   eqbox(eq)
    
}

#let tx(txt) = $#text(font:"Liberation Serif")[#txt]$
#let det = $op(tx("det"))$
#let sin = $op(tx("sin"))$
#let cos = $op(tx("cos"))$
#let max = $op(tx("max"),limits: #true)$
#let min = $op(tx("min"),limits: #true)$
#let tif = $op(tx("if"))$
#let lim = $op(tx("lim"),limits: #true)$
#let ln = $op(tx("ln"))$
#let inf = $op(tx("inf"))$
#let Cov = $op(tx("Cov"))$
#let Var = $op(tx("Var"))$
#let exp = $op(tx("exp"))$
#let argmax = $op(tx("argmax"),limits:#true)$
#let argmin = $op(tx("argmin"),limits:#true)$

#let cdots = $dots.c$
#let pd(num,denom) = $ (diff num)/(diff denom) $



#show "、":"，"
#show "。":"．"

#show "線型": "線形"

#show "函数": "関数"