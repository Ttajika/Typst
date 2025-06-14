//例

#import "lib/template.typ":* //マークシートのテンプレートを読み込む
#import "@preview/cetz:0.3.4" //図を描くためのパッケージ
#import "@preview/rexllent:0.2.3": xlsx-parser //excelの表を取り込む機能

//変数の設定
#let 科目 = { 
  [//角カッコは必要
  科目名 //科目名はここを変更
  ] 
}
#let 担当教員 = {
  [担当教員名 //担当教員名はここを変更
]
}

//以下でマークシート用テンプレートの設定を行う
#show: project.with(
  title:[#科目 期末試験 (#担当教員 担当)],
  N:75, //問題数（解答用紙のみに反映される）
  body-font:("New Computer Modern", "Harano Aji Mincho"), //本文フォント//フォントを二つ以上指定している場合，左から順に優先度があり，優先度の高いフォントにない文字が次の優先度のフォントで表示されます．
  sans-font:("New Computer Modern Sans", "Harano Aji Gothic"), //強調フォント
  math-font:("New computer modern math", "Harano Aji Mincho"), //数式フォント
  show-answer:false, //これをtrueにすると解答を問題に出すことができる．設計ミスを検知するためにお使いください．
  kaito-title:[#科目　*解答用紙* ], //解答用紙のタイトル
  kaito-ichiran:[#科目 *正答一覧*],　//正答一覧のタイトル
  show-answers-table:true, //trueで正答一覧の正答を表示、falseで非表示
  show-points-table:true, //trueで正答一覧の配点を表示、falseで非表示
)
//本文はここに書く

#set heading(numbering: "大問1.1")
//heading（見出し）の番号付の設定

#show heading: set text(weight:700 ) //見出しのウェイトを変更



=
// = で見出しを表す．== のように重ねるごとに見出しのレベルが下がる

#let sentaku = [最も適当なものを次の#choicelist(4)の中から選べ．]
// #let命令で関数や変数を作ることができる．よく使う言い回しは変数にしておくと一括で変更するときに楽．



次の #monref() から #monref(at:<second>) まで, 最も適当なものを選択肢欄の#choicelist(4)の中から選べ．

#mondai[
#lorem(10)
#sentaku 
//blockで囲う
#block(
  setmon(answer:3,point:2)+choicebox(("アレイ", "牛", "イオン", "たぬき"))
  )
]
//引数answerで正答番号，pointで点数を指定する．
//choiceで選択肢欄を作ることができる．

#answer-mode-only[解答を表示するとき専用のメモ．問題には表示できないメモ書きなどに利用]

#mondai[
 #Qunderline(label:"y")[あいうえお]という．そうすると#Qbox(label:"x")は日本国憲法を発布した．#Qparen()
#Qref("y")と#Qref("x")について，#sentaku 

#block[#setmon(answer:1,point:3)#choicebox(row:2,
([$x^2$], $integral_0^1 x^2 dif x$, [xx], [
#lorem(5)])
)
]]
//choiceboxで選択肢欄はrowに数を指定すると行数を変えることができる．


=  <second>
//headeingにはラベルがつけられる


#monref(at:<second>,add:1) から #monref(mode:"f")までは数学の問題．空欄に入る数字をそのまま答えなさい．ただし #monref(mode:"")#monref(mode:"") は二桁の数字を表す．
//headingにつけるラベルでその位置での最新の問題番号を参照する. 引数addで番号を足す.


#mondai[
次の計算をしなさい．
$
sum_(x=1)^oo 1/x^2 = pi^#setmon(answer:2,point:0, pattern:2)/#setmon(answer:6, point:8,pattern:8,label:"z")
$
//セット採点の場合は引数patternを最後以外は2, 最後を8にする．得点は最後以外を0にする

ただし #monref(label:"z",stroke: (dash:"dotted", thickness:.5pt)) には偶数が入る．
]

#mondai[
1〜6 までの数字の中から偶数を3つ選びなさい

#setmon(answer:2,pattern:1, point:2) #setmon(answer:4, pattern:1, point:2) #setmon(answer:6, pattern:9, point:2)
//順不同の場合は引数patternを最後以外を1, 最後を9にする．得点は最後のものが１個あたりの点数として採用される．
]

#mondai[
  #let newul(label:none,body) = Qunderline(label:none,numbering-style:"A",body,offset:2pt)
  //#letを使って命令を新しく作ることができます．この場合は番号の書式を変更して，番号付き下線を新しく定義し直しています．
  #newul[２つの二桁の数字を選んでください]. 空欄や下線部に振る数字・文字は変えることができます．
  
  #setmon(answer:8,point:0,pattern:2)#setmon(answer:1,point:0,pattern:2)
  #setmon(answer:3,point:0,pattern:2)#setmon(answer:9,point:8, pattern:8)
]

#mondai[まとめて作成

セット問題 #setmons(answers:(2,3,4),pattern:"set", point:3,space:1em/3) 
順不同
#setmons(answers:(2,3,4),pattern:"npo", point:2,space:1em/3) 


配列として設問を作成
#let array = setmons(answers:(9,0,3),pattern:"set", point:4,mode:"array")

$
#array.at(0) = 2 #array.at(1) + 3#array.at(2)
$
]


#pagebreak()


#set enum(numbering: "(1)", spacing: 2em)

+ 価格は$sfrac(#setmon(answer:1, point:0, pattern:2)#setmon(answer:3, point:0, pattern:2),#setmon(answer:2, point:2, pattern:8))$

+ 価格は$sfrac(#setmon(answer:1, point:0, pattern:2)#setmon(answer:3, point:0, pattern:2),#setmon(answer:2, point:2, pattern:8))$


+ 価格は$(#setmon(answer:1, point:0, pattern:2)#setmon(answer:3, point:0, pattern:2))/#setmon(answer:2, point:2, pattern:8)$




#pagebreak()
サンプル問題のTypstコード




#sample-exam


//本文はここまで



