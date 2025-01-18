#import "lib/functions.typ":*
#import "@preview/cetz:0.3.1"




#show: project.with(
  N:75, //問題数
  body-font:("New Computer Modern", "Harano Aji Mincho"), //本文フォント
  sans-font:("New Computer Modern Sans", "Harano Aji Gothic"), //強調フォント
  math-font:("New computer modern math", "Harano Aji Mincho"), //数式フォント
  show-answer:false, //これをtrueにすると解答を問題に出すことができる．
  kaito-title:[*解答用紙*], //解答用紙のタイトル
 
)




//本文はここに書く

#tutorial //ヘルプ

#help

#pagebreak() //改ページ

//以下は問題のサンプル

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
引数answerで正答番号，pointで点数を指定する．

#mondai[
 #Q_underline(label:"y")[あいうえお]という．そうすると#Q_box(label:"x")は日本国憲法を発布した．
#ref_Q("y")と#ref_Q("x")について，#sentaku 

#block[#kuran(answer:1,point:3)#choice(row:2,([$x^2$], $integral_0^1 x^2 dif x$, [xx], [
#lorem(5)
]))
]]

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


#pagebreak()
サンプル問題のTypstコード

#sample-exam


//本文はここまで



