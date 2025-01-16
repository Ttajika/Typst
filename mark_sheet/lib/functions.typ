#let choice = 10


#let response = ("0","1","2","3","4","5","6","7","8","9","A","K","P", "S", "E", "T") //学籍番号用

#let dummy = ("A","A","A","A","A","A","A")



#let def-numbering-style = "1"

#let mark-font = ("Noto Sans CJK JP")
#let mark-size = 8pt
#let mark-height = 10pt
#let mark-widhth = 10pt
#let mark-weight = 500


#let filling(answer, i) = {
    if answer == i {
      return black}
    else {return white}
  }


#let mark_ans(answer, col:black, size:mark-size,choice:choice) = {
  for i in range(choice){
    box[#ellipse(width: mark-widhth, height: mark-height, fill: filling(answer, i), stroke:.5pt+col)[#align(center+horizon,)[#text(size:size, fill: if answer == i {black} else {black})[#i]]] ]+h(5pt)  
  }
}

#let mark_answer(answers, N, numbering-style:def-numbering-style,choice:choice) = {
  let n = answers.len()
  let question = ()
  for i in range(N) {
    question.push(text(font:mark-font, size:10pt, weight:mark-weight)[#numbering(numbering-style,i+1)])
    question.push(mark_ans( if i < n {answers.at(i)} else {},choice:choice))
  }
  return question
}
#let maru = box[#circle(stroke:4pt, radius: 8pt)]





#let IDs(dummy,response) = {
let IDs = ()
let num = 7
let rnum = response.len()
for i in range(rnum) {
    IDs.push([#response.at(i)])
  for j in range(num){
    IDs.push(box[#ellipse(width: mark-widhth, height: mark-height, fill: filling(dummy.at(j), response.at(i)), stroke:.5pt)[#align(center+horizon,)[#text(size:mark-size,fill: if dummy.at(j) == response.at(i) {black} else {black},response.at(i))]] ])  
  }  
}
return IDs
}




#let studentID(dummy, response) = {
return table(columns:8,[],align:center+horizon,table.cell(colspan: 7, align:center+horizon)[学籍番号],[#hide[x]],[],[],    [],[],[],[],[],..IDs(dummy,response),
    stroke: (x,y) => {
    if x == 0 {(left:0pt)}  
    else if y <= 1 {1pt} else if x == 1 {(left:1pt)} else if x == 7 {(right:1pt)} else  {(left:.5pt, right:.5pt)} 
    if y == response.len()+1 and x>=1 {(bottom:1pt)} 
    
    }
  )

}

#let hanrei = table(columns:(23pt,auto),stroke:0pt,[],[#mark_ans("", col:white, size:10pt)])

#let marked-sheet(answers:(), N:60, response:response, dummy:dummy, texts:"",choice:choice) = {

  set page(paper:"a4",flipped: true, margin:(left:0.5cm,right:0.5cm, top:1cm, bottom:1cm), header: [#maru #h(1fr) #text(size:15pt)[#texts] #h(1fr) #maru ], footer: [#maru #h(1fr) #maru ])
  
  grid( columns:(.5cm, auto,auto, auto,auto, .5cm), row-gutter:0pt, column-gutter: 10pt,
  [],[],[#hanrei],[#h(5.8pt)#box(hanrei)],[#h(5.9pt)#box(hanrei)],[],
  [],[#studentID(dummy,response)  #table(align:center+horizon, stroke: (x,y)=>{ if x>= 1 {1pt}}, columns:(18pt,80*1.75pt),[],[氏名],[],[#hide[氏名\ 氏名]])], grid.cell(colspan:3,columns(3, gutter:0pt)[#table(columns:(23pt,auto), align:center+horizon,..mark_answer(answers, N,choice:choice))] ))

}

#let kuranbox(body, x:0) = box(stroke: (thickness:1pt,dash: if x == 0 {"solid" } else {"dashed"}),width:1.5em, height: 1.0em, baseline: 10%)[#align(center+horizon)[#body]]

#let a = ("")*7


#let kuran(numbering-style:def-numbering-style, label:none, answer:none, point:none, font:mark-font, pattern:0) = {
  counter("kuran").step()
  context{
    let num = counter("kuran").get().at(0)
    let show-answer = counter("showanswer").get().at(0)
    kuranbox()[#text(font:mark-font, weight: mark-weight)[#numbering(numbering-style,num) ]]+if show-answer == 1 {text(fill:red)[ #answer ]}
    if answer != none {counter("kuran-"+str(num)).update(answer)}
    if label !=none {counter("kuran-"+label+"-tx").update(num)}
    if point != none {counter("kuran-"+str(num)+"point").update(point)}
    counter("kuran-"+str(num)+"pattern").update(pattern)
  }
}

#let refku(numbering-style:def-numbering-style,label, font:mark-font) = {
  context{
  let num = counter("kuran-"+label+"-tx").get().at(0)
  kuranbox(x:1)[#text(font:mark-font, weight: mark-weight)[#numbering(numbering-style,num)]]
  }
}

//設定
#let project(
    N:75,
    body-font:("Noto Serif", "Harano Aji Mincho"),
    sans-font:("Noto Sans", "Harano Aji Gothic"),
    math-font:("New computer modern math", "Harano Aji Mincho"),
    show-answer:false,
    response:response,
    
    body
    ) = {
    for i in range(N) {
      counter("kuran-"+str(i+1)).update(1000)
        }
    set page("a4", margin:1cm, numbering: "1")
    set text(size:12pt,font:body-font) //地の文のフォント設定
    set par(first-line-indent: 1em)
    show strong: set text(font:sans-font,weight: 500) //強調のフォント設定
    show heading: set text(font:sans-font,weight: 500) //見出しのフォント設定
    show math.equation: set text(font:math-font) //数式フォント設定
    if show-answer {counter("showanswer").update(1)} //解答を見せる

    body
  
    context[
      #let total-points = 0
      #let answers = ()
      #let points = ()
      #let patterns = ()
      #for i in range(N) {
        answers.push(counter("kuran-"+str(i+1)).get().at(0))
        points.push(counter("kuran-"+str(i+1)+"point").get().at(0))
        total-points += counter("kuran-"+str(i+1)+"point").get().at(0)
        patterns.push(counter("kuran-"+str(i+1)+"pattern").get().at(0))
      }
      //解答マークシート
      #marked-sheet(answers:answers, response:response, texts:[*正答マークシート*], N:N)
      //配点マークシート
      #marked-sheet(answers:points, response:response,dummy:("0")*7,texts:[ *配点マークシート*  満点: #total-points ], N:N)
      //採点パターン
      #marked-sheet(answers:patterns, response:response, dummy:("1")*7,texts:[ *採点パターンマークシート* ], N:N)
      ]
      marked-sheet(dummy:("","","","","","",""),texts:[*解答用紙*], response:response, N:N)
}


#let help ={[
- これはマークシート式試験のテンプレートです

- 以下の特徴があります
  - 無料で使用可能
  - 解答番号は自動連番
  - 自動連番の番号付き下線や空欄を利用できる
  - 解答や配点，採点パターン認識用マークシートを自動作成
  - 付属の採点プログラムに読み込ませるだけで採点できる
  - 総得点も自動計算できるので，満点を容易に計算可能
  
- マークシートの読み取りには#link("https://sites.google.com/site/examgrader/formscanner",[FormScanner])を用いる．

  - 使い方は，例えば以下を参照
    - https://harucharuru.hatenablog.com/entry/2020/01/14/182020
  - FormScannerで作成したcsvファイルを#link("https://colab.research.google.com/drive/1jRxTq22NM54GMllzE5MNWnxU3uPjYfSh?usp=sharing",[採点プログラム(python製)])で処理する

- FormScannerの設定は以下のようにしています
  - 閾値は30, 濃度は40, マーカーのサイズは15
  - 設問名テンプレートQ\#\#\#
  - 学籍番号の設定は1. 列ごとの設定，設問グループを "ID"に設定；一番初めにやってください
  - 問は1. 行ごとの設定，設問グループはなんでもOK
- 採点プログラムは以下のものが使えます．  
  - https://colab.research.google.com/drive/1jRxTq22NM54GMllzE5MNWnxU3uPjYfSh?usp=sharing

  - 上記採点プログラムを用いる場合は配点シート，正答シート，採点パターンシート全てをスキャンしてください．

- Typstの使い方
  - 公式ドキュメント(和訳)：https://typst-jp.github.io/docs/
  - チュートリアル: https://qiita.com/tomoyatajika/items/649884befe95c5f1dcea
  

]}

#let Q_underline(label:none,numbering-style:"ア",body) = {
  counter("toi").step()
  context{
  text(size:0.5em)[(#numbering(numbering-style,counter("toi").get().at(0)))]+underline(body)
  if label != none {counter("toi"+label).update(counter("toi").get().at(0))}
}
}
#let Q_box(label:none,numbering-style:"ア") = {
  counter("toi").step()
  context[
  #box(height:12pt,width:15pt, stroke:1pt,baseline: 1pt)[#align(center+horizon)[#text(size:0.8em)[#numbering(numbering-style,counter("toi").get().at(0))]]]
  #if label != none {counter("toi"+label).update(counter("toi").get().at(0))}
  ]
}

#let ref_Q(label,numbering-style:"ア") = {context[#numbering(numbering-style,counter("toi"+label).get().at(0))]}

#let choice(candidate) = {
  let n = candidate.len()
  let col = (14pt, 1fr)*n
  let narray = ()
  for i in range(n) {
    narray.push(box[#ellipse(width: 10pt, height: 10pt, stroke:.5pt)[#align(center+horizon,)[#text(size:8pt)[#numbering("1",i+1)]]]])
    narray.push(candidate.at(i))
  }
  [#box(stroke:1pt,inset:10pt,grid(columns:col,..narray))]}




#let mondai(body) = {
  counter("mondai").step()
  block(width:100%)[#context[#strong[問題 #numbering("1.",counter("mondai").get().at(0))]
  #body 
  ]]
}