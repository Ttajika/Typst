#import "lib/functions.typ":*
#import "@preview/cetz:0.3.1"

#set page("a4", margin:1cm)
#set text(size:12pt,font:("Noto Serif", "Harano Aji Mincho"))
#show strong: set text(font:("Noto Sans", "Harano Aji Gothic"),weight: 300)
#show heading: set text(font:("Noto Sans", "Harano Aji Gothic"),weight: 500)
#show math.equation: set text(font:("New computer modern math", "Harano Aji Mincho"))
#let N = 46
#for i in range(N) {
  counter("kuran-"+str(i+1)).update(1000)
}

#let mondai(body) = {
  counter("mondai").step()
  context[#strong[問題 #numbering("1.",counter("mondai").get().at(0))]

  #body 
  ]
}
#let sentaku = "このとき，最も適当なものを次の１〜４の中から選べ．"

#let choice(candidate) = {
  let n = candidate.len()
  let col = (14pt, 1fr)*n
  let narray = ()
  for i in range(n) {
    narray.push(box[#ellipse(width: 10pt, height: 10pt, stroke:.5pt)[#align(center+horizon,)[#text(size:8pt)[#numbering("1",i+1)]]]])
    narray.push(candidate.at(i))
  }
  [#box(stroke:1pt,inset:10pt,grid(columns:col,..narray))]}

//#counter("showanswer").update(1) //解答を見せる

//本文はここに書く
マークシートの読み取りにはFormScannerを用いる．

使い方は，例えば以下を参照
https://harucharuru.hatenablog.com/entry/2020/01/14/182020

Typstの使い方は https://qiita.com/tomoyatajika/items/649884befe95c5f1dcea




= [科目名]:期末試験

#mondai[
#lorem(20)
#sentaku 

#kuran(answer:3,point:2)#choice(("アレイ", "牛", "イオン", "たぬき"))
]

#mondai[
#lorem(20)
#sentaku 

#kuran(answer:1,point:3)#choice(([$x^2$], $integral_0^1 x^2 dif x$, [xx], [

  #cetz.canvas(length:0.4cm,{
  import cetz.draw: *
set-style(
  stroke: 0.4pt,
  grid: (
    stroke: gray + 0.2pt,
    step: 0.5
  )
)
grid((-1.5, -1.5), (1.5, 1.5))
line((-1.5, 0), (1.5, 0))
line((0, -1.5), (0, 1.5))
circle((0, 0))
arc((3mm, 0), start: 0deg, stop: 30deg, radius: 3mm)})
]))
]


#mondai[
次の計算をしなさい．
$
sum_(x=1)^oo 1/x^2 = pi^#kuran(answer:2,point:0)/#kuran(answer:6, point:8)
$



]

//本文はここまで



#context[
#let total-points = 0
#let answers = ()
#let points = ()
#for i in range(N) {
  answers.push(counter("kuran-"+str(i+1)).get().at(0))
  points.push(counter("kuran-"+str(i+1)+"point").get().at(0))
  total-points += counter("kuran-"+str(i+1)+"point").get().at(0)
}

//解答マークシート
#marked-sheet(answers:answers, texts:[正答マークシート])
//配点マークシート
#marked-sheet(answers:points, dummy:("0")*7,texts:[ 配点マークシート  満点: #total-points ])

]
#unmarked-sheet
