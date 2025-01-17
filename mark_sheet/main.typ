#import "lib/functions.typ":*
#import "@preview/cetz:0.3.1"




#show: project.with(
  N:75, //問題数
  body-font:("New Computer Modern", "Harano Aji Mincho"), //本文フォント
  sans-font:("New Computer Modern Sans", "Harano Aji Gothic"), //強調フォント
  math-font:("New computer modern math", "Harano Aji Mincho"), //数式フォント
  show-answer:false, //これをtrueにすると解答を問題に出すことができる．
  response: ("0","1","2","3","4","5","6","7","8","9","A","K","P", "S", "E", "T") //学籍番号用 
  //0,1,Aは正答マークシートなどの識別に使うので必要
)





//本文はここに書く

#help //ヘルプ

#pagebreak() //改ページ

//以下は問題のサンプル

= サンプル問題[科目名]:期末試験
#let sentaku = "このとき，最も適当なものを次の１〜４の中から選べ．"
次の #refKN() から #refKN(mode:"f") まで答えなさい．#refKN(label:"z")

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

#kuran(answer:1,point:3)#choice(([$x^2$], $integral_0^1 x^2 dif x$, [xx], [
#lorem(5)
]))
]


#mondai[
次の計算をしなさい．
$
sum_(x=1)^oo 1/x^2 = pi^#kuran(answer:2,point:0, pattern:2)/#kuran(answer:6, point:8,pattern:8,label:"z")
$
//セット採点の場合は引数patternを最後以外は2, 最後を8にする．得点は最後以外を0にする

ただし #refku("z") には偶数が入る．//番号を再利用するには`#refku`を用いる．ラベルを用いて参照できる．


]

#mondai[
1〜6までの数字の中から偶数を３つ選びなさい

#kuran(answer:2,pattern:1, point:2)#kuran(answer:4, pattern:1, point:2)#kuran(answer:6, pattern:9, point:2)
//順不同の場合は引数patternを最後以外を1, 最後を9にする．得点は最後のものが１個あたりの点数として採用される．
]

#mondai[
  #let newul(label:none,body) = Q_underline(label:none,numbering-style:"A",body)
  #newul[４つの数字を選んでください]. 空欄や下線部に振る数字・文字は変えることができます．
  
  #kuran(answer:8,point:0,pattern:2)#kuran(answer:1,point:0,pattern:2)#kuran(answer:3,point:0,pattern:2)#kuran(answer:9,point:8, pattern:8)
]



//本文はここまで



