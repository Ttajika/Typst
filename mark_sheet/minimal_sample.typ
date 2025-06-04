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

#mondai[
//setmonRを用いると選択肢をランダムにすることができる．ansで正解選択肢を指定，otherでその他の選択肢を指定，そしてquestionで問題文を指定する．rondomize_keyでテキトーに数字を指定しランダムにする．ここを固定すると正答番号や並び順がそのまま固定されるので注意
#setmonR(ans:[あいうえお], other:([かきくけこ], [さしすせそ], [たちつてと]), point:2, question:[あ行を選びなさい], randomize_key:2 ) 
]




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






#set page(flipped: true)
= 解答用紙記入上の注意


#align(left)[
※各列で該当する文字・数字の○を黒く塗りつぶしてください。\
※複数選択は無効になります。]


以下は，学籍番号が12KA337の学生が，#kuranbox(1) に 8 を，#kuranbox(2) に 0 を， #kuranbox(3) に 2を解答するケースの記入方法です．



    #columns(2, gutter:-0pt)[ //マルチコラム. 列の数は解答マーク欄の列数と学籍番号
    #exstudentID(("1", "2", "K", "A", "3", "3", "7"), //塗りつぶす配列
               response, //選択肢の配列
               ID_num:ID_num, //学籍番号の桁数 
               )//学籍番号マーク等
    #colbreak()
    #table(
      columns:(23pt,auto), //列の幅：設問番号と解答欄
      stroke: (x,y) => {if y == 0 {(bottom:1pt)} else {1pt}},
      align:center+horizon, 
      table.header(text(0.4em)[解答\ 番号],[#mark_ans("", col:white, size:12pt,choice:10)]), //解答マーク欄のヘッダー
      ..mark_answer((8,0,2), 3, numbering-style:"1", choice:10))]