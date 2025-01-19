#let choice = 10


#let response = ("0","1","2","3","4","5","6","7","8","9","A","K","P", "S", "E","D","F","H", "T")//学籍番号用

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
  [],[],[#hanrei],[#if N>25{h(5.8pt)+box(hanrei)}],[#if N>50{h(5.9pt)+box(hanrei)}],[],
  [],[#studentID(dummy,response)  #table(align:center+horizon, stroke: (x,y)=>{ if x>= 1 {1pt}}, columns:(18pt,80*1.75pt),[],[氏名],[],[#hide[氏名\ 氏名]])], grid.cell(colspan:3,columns(3, gutter:0pt)[#table(columns:(23pt,auto), align:center+horizon,..mark_answer(answers, N,choice:choice))] ))

}

#let kuranbox(body,width:1.5em, height: 1.0em, stroke:"default", x:0) = box(stroke: if stroke == "default"{ (thickness:1pt,dash: if x == 0 {"solid" } else {"dotted"})} else {stroke},width:width, height: height, baseline: 10%)[#align(center+horizon)[#body]]

#let a = ("")*7


#let arrange-stroke(pattern) = {
  if pattern == 0 {1pt+black}
  else if pattern == 2 or pattern == 8 {(paint:blue, thickness:1pt  )}
  else if pattern == 1 or pattern == 9 {(paint:green.darken(50%), thickness:1pt  )}
}

#let kuran(numbering-style:def-numbering-style, label:none, answer:none, point:none, font:mark-font, pattern:0) = {
  counter("kuran").step()
  context{
    let num = counter("kuran").get().at(0)
    let show-answer = counter("showanswer").get().at(0)
    kuranbox(stroke:if show-answer == 1 {arrange-stroke(pattern)} else {"default"} )[#text(font:mark-font, weight: mark-weight)[#numbering(numbering-style,num) ]]+if show-answer == 1 {text(fill:red)[ #answer ]+if pattern == 8 {text(fill:blue, size:0.5em )[set end]} }
    if answer != none {counter("kuran-"+str(num)).update(answer)}
    if label !=none {counter("kuran-"+label+"-tx").update(num)}
    if point != none {counter("kuran-"+str(num)+"point").update(point)}
    counter("kuran-"+str(num)+"pattern").update(pattern)
  }
}

#let refku(numbering-style:def-numbering-style,label,  font:mark-font) = {
  context{
  let num = counter("kuran-"+label+"-tx").get().at(0)
  kuranbox(x:1)[#text(font:mark-font, weight: mark-weight)[#numbering(numbering-style,num)]]
  }
}

#let kaitoran(numbering-style:def-numbering-style,answers, points, patterns, show-answer, show-point, total-points) = {
  context{
  let pattern-search-s = () //順不同 or セット採点始まり
  let pattern-search-m = ()
  let pattern-search-l = () //順不同 or セット採点終わり
  let tab = ()
  let total-number = counter("kuran").get().at(0)
  for num in range(total-number){
  tab.push([#text(font:mark-font, weight: mark-weight)[#numbering(numbering-style,num+1) ]])
  tab.push([#if show-answer {answers.at(num)}])
  tab.push([#if show-point {if patterns.at(num) != 2 {[#points.at(num)]}+ if  patterns.at(num) == 9 {h(1fr)+text(0.5em)[(順不同)]} else if patterns.at(num) == 8 {text(0.5em)[#h(1fr) (セット)]}}])
  if num > 0 and (patterns.at(num)*patterns.at(num -1 ) == 1 or patterns.at(num) * patterns.at(num -1) == 4) {pattern-search-m.push(num)}
  else  if patterns.at(num) == 1 or patterns.at(num) == 2 {pattern-search-s.push(num)}
  if patterns.at(num) == 8 or patterns.at(num) == 9 {pattern-search-l.push(num)}
  
}
table(columns:(40pt,50pt,50pt), stroke: (x,y)=> {if x == 2 and pattern-search-m.contains(y -1 ) {( left:1pt, right:1pt)} else if x == 2 and pattern-search-s.contains(y - 1) {(top:1pt , left:1pt, right:1pt)} else if x == 2 and pattern-search-l.contains(y -1 ) {(left:1pt, right:1pt, bottom:1pt)}  else {1pt}}, align:horizon,[問題],[正答],[配点],..tab,[計],[],[#total-points])
}
}

//設定
#let project(
    N:75,
    body-font:("Noto Serif", "Harano Aji Mincho"),
    sans-font:("Noto Sans", "Harano Aji Gothic"),
    math-font:("New computer modern math", "Harano Aji Mincho"),
    mono-font:("Liberation mono", "Harano Aji Gothic"),
    show-answer:false,
    kaito-title:[*解答用紙*],
    kaito-ichiran:[*正答一覧*],
    response:response,
    show-answers-table:false,
    show-points-table:true,
    
    
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
    show raw: set text(font:mono-font)
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

      #pagebreak() 
      //解答及び配点一覧
      #if show-answers-table or show-points-table {
        columns(3)[
        #heading(numbering: none)[#kaito-ichiran]
        #kaitoran(numbering-style:def-numbering-style,answers, points, patterns, show-answers-table, show-points-table, total-points)]
      }
      //解答マークシート
      #marked-sheet(answers:answers, response:response, texts:[*正答マークシート*], N:N)
      //配点マークシート
      #marked-sheet(answers:points, response:response,dummy:("0")*7,texts:[ *配点マークシート*  満点: #total-points ], N:N)
      //採点パターン
      #marked-sheet(answers:patterns, response:response, dummy:("1")*7,texts:[ *採点パターンマークシート* ], N:N)
      ]
      marked-sheet(dummy:("","","","","","",""),texts:[#kaito-title], response:response, N:N)
}

#let help = {
  [#heading(numbering: none)[コマンドヘルプ]
作りかけです.

- ```typst #kuran(answer:整数, point:整数, pattern:整数, numbering-style:文字列)```
    - 問番号の欄 #kuran()を作成する．番号は自動連番される．
    - 引数（省略時はデフォルトが採用される）
          - `answer`：正答番号. ここに記入すれば正答マークシートに反映される
          - `point` ： 配点．ここに記入すれば配点マークシートに反映される
          - `pattern`：採点パターン．ここに記入すれば採点パターンマークシートに反映される
          - `numbering-style`:ナンバリングのスタイル．デフォルトは```typst "1" ```
    - 採点方法について
      - 採点パターンを省略すれば，通常の採点，つまり欄一つにつき，その配点がなされる
      - セット採点：複数の欄すべてが正解のときのみ点数を与えるにはセットにする最後の欄のpatternを8に，それ以外を２にする. 配点は最後の欄のものが有効
      - 順不同採点：複数の欄のうち，順不同採点を行う．部分点はありである．このときには最後の欄のpatternを9に，それ以外を1にする. 配点は最後の欄のものが有効
  
  ]
  counter("kuran").update(0)
}



#let tutorial ={[
- これはマークシート式試験のテンプレートです

- 以下の特徴があります
  - 無料で使用可能
  - 解答番号は自動連番
    - ラベルをつけて参照可能
  - 自動連番の番号付き下線や空欄を利用できる
    - ラベルをつけて参照可能
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
  - スキャン後生成されたcsvをgoogle colabにアップしてください
    - アップしたくない場合はローカルでpythonを動かしてください．

- Typstの使い方
  - 公式ドキュメント(和訳)：https://typst-jp.github.io/docs/
  - チュートリアル: https://qiita.com/tomoyatajika/items/649884befe95c5f1dcea

- このテンプレートファイル https://typst.app/project/rI6YUx8eQIafMKP0hRZ1B6

- 使い方をすべて解説してほしい場合はメールでご依頼ください $->$ #link("mailto:tajika.tomoya@nihon-u.ac.jp")

]}

#let Q_underline(label:none,numbering-style:"ア",body) = {
  counter("toi").step()
  context{
  text(size:0.7em)[(#numbering(numbering-style,counter("toi").get().at(0)))]+underline(body)
  if label != none {
    counter("toi"+label).update(counter("toi").get().at(0))
    counter("toi"+label+"kind").update(1)
    }
}
}
#let Q_box(label:none,numbering-style:"ア") = {
  counter("toi").step()
  context[
  #box(height:12pt,width:15pt, stroke:1pt,baseline: 1pt)[#align(center+horizon)[#text(size:0.8em)[#numbering(numbering-style,counter("toi").get().at(0))]]]
  #if label != none {
      counter("toi"+label).update(counter("toi").get().at(0))
      counter("toi"+label+"kind").update(2) 
      }
  ]
}

#let ref_Q(label,numbering-style:"ア") = {
  context{
    let kind = counter("toi"+label+"kind").get().at(0)
    if kind == 1 {"下線部"} else if kind == 2 {"空欄"}
    numbering(numbering-style,counter("toi"+label).get().at(0))
    } 
    }

#let choice(candidate, row:1, row-size:auto) = {
  let n = candidate.len()
  let col = (14pt, 1fr)*int(n/row) 
  let narray = ()
  for i in range(n) {
    narray.push(box[#ellipse(width: 10pt, height: 10pt, stroke:.5pt)[#align(center+horizon,)[#text(size:8pt)[#numbering("1",i+1)]]]])
    narray.push(candidate.at(i))
  }
  [#box(stroke:1pt,inset:1em,grid(align:horizon,columns:col,rows:row-size,row-gutter: 1em,..narray))]}


#let refKN(label:none, mode:none, n:1, numbering-style:def-numbering-style, at:none, stroke:"default", width:1.5em) = {
  context{
  let num = {if mode == none and label == none and at == none {n}
              else if at != none {counter("kuran").at(at).at(0)}
              else if label != none {counter("kuran-"+label+"-tx").final().at(0)}
              else if mode == "f" {counter("kuran").final().at(0)}} 
  kuranbox(stroke:stroke, width:width)[#text(font:mark-font, weight: mark-weight)[#numbering(numbering-style,num) ]] 
  }
}
#let mondai(body,name:"問題") = {
  counter("mondai").step()
  block(width:100%)[#context[#strong[#name #numbering("1.",counter("mondai").get().at(0))]
  #body 
  ]]
}



#let sample-exam = {
  [```typst
#import "lib/functions.typ":*

#show: project.with(
  N:75, //問題数
  body-font:("New Computer Modern", "Harano Aji Mincho"), //本文フォント
  sans-font:("New Computer Modern Sans", "Harano Aji Gothic"), //強調フォント
  math-font:("New computer modern math", "Harano Aji Mincho"), //数式フォント
  show-answer:false, //これをtrueにすると解答を問題に出すことができる．
)

#set heading(numbering: "大問1.1")


#heading(numbering:none)[サンプル問題[科目名]:期末試験]

=
#let sentaku = "最も適当なものを次の１〜４の中から選べ．"
次の #refKN() から #refKN(at:<second>) まで, 最も適当なものを選択肢欄の１〜４の中から選べ．

#mondai[
#lorem(10)
#sentaku 
//blockで囲う
#block(kuran(answer:3,point:2)+  choice(("アレイ", "牛", "イオン", "たぬき")))
]
//引数answerで正答番号，pointで点数を指定する．
//choiceで選択肢欄を作ることができる．

#mondai[
 #Q_underline(label:"y")[あいうえお]という．そうすると#Q_box(label:"x")は日本国憲法を発布した．
#ref_Q("y")と#ref_Q("x")について，#sentaku 

#block[#kuran(answer:1,point:3)#choice(row:2,([$x^2$], $integral_0^1 x^2 dif x$, [xx], [
#lorem(5)
]))
]]
//choiceで選択肢欄はrowに数を指定すると行数を変えることができる．


=  <second>

#context[#refKN(n:counter("kuran").get().at(0)+1) から #refKN(mode:"f")までは数学の問題．空欄に入る数字をそのまま答えなさい．]



#mondai[
次の計算をしなさい．
$
sum_(x=1)^oo 1/x^2 = pi^#kuran(answer:2,point:0, pattern:2)/#kuran(answer:6, point:8,pattern:8,label:"z")
$
//セット採点の場合は引数patternを最後以外は2, 最後を8にする．得点は最後以外を0にする

ただし #refku("z") には偶数が入る．//番号を再利用し，それとわかるようにするには`#refku`を用いる．ラベルを用いて参照できる．#refKN("z")ならそのまま再利用．


]


#mondai[
1〜6までの数字の中から偶数を３つ選びなさい

#kuran(answer:2,pattern:1, point:2)#kuran(answer:4, pattern:1, point:2)#kuran(answer:6, pattern:9, point:2)
//順不同の場合は引数patternを最後以外を1, 最後を9にする．得点は最後のものが１個あたりの点数として採用される．
]


#mondai[
  #let newul(label:none,body) = Q_underline(label:none,numbering-style:"A",body)
  //#letを使って命令を新しく作ることができます
  #newul[２つの二桁の数字を選んでください]. 空欄や下線部に振る数字・文字は変えることができます．
  
  #kuran(answer:8,point:0,pattern:2)#kuran(answer:1,point:0,pattern:2)
  #kuran(answer:3,point:0,pattern:2)#kuran(answer:9,point:8, pattern:8)
]





```]
}