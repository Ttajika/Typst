//----------------最小限の例--------------------------------------

//------------パッケージの読み込み--------------------------
#import "lib/template.typ":* //マークシートのテンプレートを読み込む
#import "@preview/cetz:0.3.4" //図を描くためのパッケージ
#import "@preview/rexllent:0.2.3": xlsx-parser //excelの表を取り込む機能
//-----------------------------------------------------


//-------------変数の設定-------------------------------------------
#let 科目 = "科目名" //科目名はここを変更する
#let 担当教員 = "担当教員名"//担当教員名はここを変更
//-----------------------------------------------------------------

//----------以下でマークシート用テンプレートの設定を行う-----------------
#show: project.with(
  title:[#科目 期末試験 (#担当教員 担当)],
  N:15, //問題数（解答用紙のみに反映される）
  body-font:("New Computer Modern", "Harano Aji Mincho"), //本文フォント//フォントを二つ以上指定している場合，左から順に優先度があり，優先度の高いフォントにない文字が次の優先度のフォントで表示されます．
  sans-font:("New Computer Modern Sans", "Harano Aji Gothic"), //強調フォント
  math-font:("New computer modern math", "Harano Aji Mincho"), //数式フォント
  show-answer:false, //これをtrueにすると解答を問題に出すことができる．
  kaito-title:[#科目 (#担当教員) *解答用紙* ], //解答用紙のタイトル
  kaito-ichiran:[#科目 (#担当教員) *正答一覧*],　//正答一覧のタイトル
  show-answers-table:true, //trueで正答一覧の正答を表示、falseで非表示
  show-points-table:true, //trueで正答一覧の配点を表示、falseで非表示
)
//--------------------ここまでが設定------------------------------------

//------------------ここからが問題本文-----------------------------------


//#mondaiという関数によって，通し番号をつけた問題を設定する．[]で括られた部分で一つの問題を構成する．
#mondai[//問題開始
#block[
#setmon(answer:3,point:2) //当該選択肢欄の解答と配点を指定
次の中で，百貨店を選べ．\
#choicebox(("アレイ", "牛", "イオン", "たぬき"))
]

]//問題終了

//引数answerで正答番号，pointで点数を指定する．
//choiceで選択肢欄を作ることができる．


//次の問題へ
#mondai[
#Qunderline(label:"y")[あいうえお]という．そうすると#Qbox(label:"x")は日本国憲法を発布した．#Qparen(label:"u")年の出来事である．
//--#Qunderline, Qbox, Qparenは共通の通し番号を持った下線，四角囲み空欄，カッコ空欄．label: "tag"で，その番号を参照できる．通し番号のデフォルトはカタカナだが変更もできる．docsを参照

 
#block[
#setmon(answer:7,point:3) //当該選択肢欄の解答と配点を指定
#Qref("y")に関連するものとして，最も適切なものをひとつ選べ．\
#choicebox(row:2,
([$x^2$], 
$integral_0^1 x^2 dif x$, //数式はLaTeXと若干書き方が異なる．
[xx], 
[#lorem(5)])
)
]


#block[
#setmon(answer:5,point:3)
#Qref("x")に入るものとして，最も適切なものをひとつ選べ．\
#choicebox(row:2,
([$x^2$], 
$integral_0^1 x^2 dif x$, 
[xx], 
[#lorem(5)]))
]

#block[
#setmon(answer:3,point:3)
#Qref("u")に入るものとして，最も適切なものをひとつ選べ．\
#choicebox(row:2,
([$x^2$], 
$integral_0^1 x^2 dif x$, 
[xx], 
[#lorem(5)]))
]

]