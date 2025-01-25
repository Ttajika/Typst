//デフォルトの設定
#let choice = 10 //解答欄の選択肢数
#let response = ("0","1","2","3","4","5","6","7","8","9","A","K","P", "S", "D","E","F","H", "T")//学籍番号用
#let dummy = ("A","A","A","A","A","A","A")
#let def-numbering-style = "1" //設問番号のナンバリング方法
#let mark-font = ("Noto Sans CJK JP") //設問欄の数字のフォント
#let mark-size = 8pt //マーク欄の文字のサイズ
#let mark-height = 10pt //マーク欄の楕円の高さ
#let mark-width = 10pt //マーク欄の楕円の幅
#let mark-weight = 500 //設問欄のフォントのウェイト
#let ID_num = 7 //学籍番号の桁数
#let kuran-width = 1.4em //空欄の幅
//Typstはグローバル変数が基本的に使えないので，カウンターをグローバル変数のように扱う.

//塗りつぶしの色設定
//-> color
#let filling(answer, i) = {
    if answer == i {
      return black}
    else {return white}
  }


//塗りつぶしの記号//ここを変えれば全部変わる
#let mark-shape(num, fill:white,col:black) = {
    return box(baseline: 10%)[
      #ellipse(//楕円を描画
                  width: mark-width, //幅
                  height: mark-height, //高さ
                  fill: fill, 
                  stroke:.5pt+col //枠の線幅と色を指定
                  )[
                    #align(center+horizon,)[#num]
                    ]
      ]

}
//正答マークシートの塗りつぶし設定（answerと番号が合えば塗りつぶし，そうでなければ番号を出力）
#let mark_ans(answer, //正答番号
              col:black, //枠の色
              size:mark-size, //フォントのサイズ
              choice:choice //選択肢数
              ) = {
  for i in range(choice){
    mark-shape(
      text(size:size, top-edge: 0.7em, fill: if answer == i {black} else {black})[#i], 
      fill:filling(answer, i), //回答とiが一致すれば塗りつぶし
      col:col
      )
    if i< choice - 1 {h(5pt)} //次の楕円との間にスペースを開ける
    }
}

//解答欄の表を作成するためのarrayを生成する
#let mark_answer(answers, //回答の配列
                N, //設問数
                numbering-style:def-numbering-style, //設問のナンバリングの仕方
                choice:choice, //選択肢数
                ) = {
  let n = answers.len() //解答がある設問の数を取得
  let question = () //生成する配列を入れる空配列を作成
  for i in range(N) {
    question.push(text(font:mark-font, size:10pt, weight:mark-weight)[#numbering(numbering-style,i+1)]) //設問番号を表示
    question.push(mark_ans( if i < n {answers.at(i)} else {},choice:choice)) //マーク欄を表示
  }
  return question //配列を出力，これを後で表に出力する
}

//FormScanner認識用の４隅の丸
#let maru = box[#circle(stroke:4pt, radius: 8pt)]




//学籍番号出力用の配列を作成
#let IDs(dummy, //塗りつぶす配列
        response, //選択肢の配列
        ID_num:ID_num, //学籍番号の桁数 
        ) = {
  let IDs = ()
  let num = ID_num
  let rnum = response.len()
  for i in range(rnum) {
      IDs.push([#response.at(i)])
      for j in range(num){
        IDs.push(
          mark-shape(
            text(size:mark-size,top-edge: 0.7em,fill: if dummy.at(j) == response.at(i) {black} else {black},response.at(i)), fill:filling(dummy.at(j), response.at(i))
            )
          )  
      }  
  }
  return IDs
}





//学籍番号のマーク欄を生成
#let studentID(dummy, //塗りつぶす配列
               response, //選択肢の配列
               ID_num:ID_num, //学籍番号の桁数 
               ) = {
  let empty_set_array = ()
  for i in range(ID_num ) { //学籍番号記入欄のための配列を作成する
    empty_set_array.push([])
  }
  //以下でマーク欄の表を作成
  return table(
    columns:ID_num + 1,
     
    align:center+horizon,
    [],table.cell(colspan: ID_num,stroke:(top:0pt, left:0pt))[#hide[#text(0.4em)[設問\ 番号]]],//高さ調整のための空行
    [],table.cell(colspan: ID_num, align:center+horizon)[学籍番号], //「学籍番号」と表示する行
    [#hide[x]],..empty_set_array, //記入欄
    ..IDs(dummy,response, ID_num:ID_num), //マーク欄
    [#hide[x]],table.cell(colspan: ID_num,stroke:(top:1pt, left:0pt))[], //空行
    [],table.cell(colspan: ID_num,stroke:1pt,align:center)[氏名], //「氏名」と表示する行
    [],table.cell(colspan: ID_num,stroke:1pt,align:center,rowspan:5)[#hide[氏名 ]], //氏名記入欄
      stroke: (x,y) => {
        if y == 0 {(top:0pt,left:0pt,bottom:0pt)}
        else if x == 0 {(left:0pt)}  
        else if y <= 2 and y>=1 {1pt} else if x == 1 {(left:1pt)} else if x == ID_num {(right:1pt)} else  {(left:.5pt, right:.5pt)} 
        if y >= response.len()+2 and x>=1 {(bottom:1pt)}  
      } //枠のルール
    )
}


///マークシートを生成
///-> content
#let marked-sheet(///塗りつぶす番号の配列
                  ///->array
                  answers:(),　
                  ///表示する問題数
                  ///-> int
                  N:75, 
                  ///学籍番号の選択肢配列
                  ///-> array
                  response:response, 
                  ///学籍番号の塗りつぶし配列
                  ///-> array
                  dummy:dummy,
                  ///マークシート用紙の上部に記載するタイトル
                  ///-> str|content
                  texts:"", 
                  ///設問の選択肢数
                  ///-> int
                  choice:choice,
                  ///学籍番号の桁数
                  ///-> int
                  ID_num:ID_num, 
                  ///設問のナンバリングの方法 
                  ///-> str
                  numbering-style:def-numbering-style, 
                  ) = {
  set page( //ページのレイアウト設定
      paper:"a4", //ページのサイズ
      flipped: true, //横向きに
      margin:(left:.5cm,right:.5cm, top:1.15cm, bottom:1.5cm), //余白
      header: [#maru #h(1fr) #text(size:15pt)[#texts] #h(1fr) #maru ], //ヘッダーの両端に認識用の二重丸
      footer: [#maru #h(1fr) #maru ])//フッターの両端に認識用の二重丸
  let n-columns = {     //解答マーク欄の列数
     calc.ceil(N/25)   
  }

  align(center,block(width:95%)[ //blockで幅を抑え，認識用二重丸マークでマーク領域をうまく囲めるようにする
    #columns(n-columns+1, gutter:-0pt)[ //マルチコラム. 列の数は解答マーク欄の列数と学籍番号
    #studentID(dummy,response, ID_num:ID_num) //学籍番号マーク等
    #table(
      columns:(23pt,auto), //列の幅：設問番号と解答欄
      stroke: (x,y) => {if y == 0 {(bottom:1pt)} else {1pt}},
      align:center+horizon, 
      table.header(text(0.4em)[設問\ 番号],[#mark_ans("", col:white, size:12pt,choice:choice)]), //解答マーク欄のヘッダー
      ..mark_answer(answers, numbering-style:numbering-style, N,choice:choice))]]) //解答マーク欄
}

//問題番号の形の設定
// 
#let kuranbox(body,
              width:kuran-width, //空欄の幅
              height: 1.2em, //空欄の高さ
              stroke:1pt,
              x:0
              ) = box(
                    stroke: stroke,
                    width:width,
                    height: height,
                    baseline: 10%)[
                      #align(center+horizon)[#body]
                      ]




#let arrange-stroke(pattern) = {
  if pattern == 0 {1pt+black}
  else if pattern == 2 or pattern == 8 {(paint:blue, thickness:2pt  )}
  else if pattern == 1 or pattern == 9 {(paint:green.darken(50%), thickness:2pt  )}
}




///設問番号の設定
///```example
///#setmon(answer:2, point:4)
/// ```
///-> content 
#let setmon(
          /// 設問番号のナンバリングの仕方
          ///-> str
          numbering-style:def-numbering-style, 
          /// 設問番号の参照用ラベル
          ///-> str 
          label:none, 
          /// 正答
          /// -> int 
          answer:none,
          ///配点
          /// -> int
          point:none, 
          /// 採点パターン
          /// -> int
          pattern:0, 
          ///マーク欄のフォント
          /// -> str|array
          font:mark-font, 
          ) = {
  counter("kuran").step() //設問番号を更新
  context{
    let num = counter("kuran").get().at(0) //現在の設問番号を取得
    let show-answer = counter("showanswer").get().at(0) //解答を表示するかどうかのカウンターを表示 1なら解答表示，0なら非表示.
    //空欄の挿入
    kuranbox(stroke:if show-answer == 1 {arrange-stroke(pattern)} else {1pt}, width:kuran-width + .7em*show-answer )[
      #align(if show-answer == 1{ right} else {center}, text(font:mark-font, weight: mark-weight)[#numbering(numbering-style,num) ]) //設問番号を挿入
      #let k-set-inpo = (1,2,8,9)
      #let k-set = (2,8)
      #let k-inpo = (1,9)
      #if show-answer == 1 and (k-set-inpo.contains(pattern)) {
          align(center)[#place(dx:0em,dy:0.3em,text(0.5em,fill:red.darken(50%), weight:700)[
          #if k-set.contains(pattern) {[セ]} 
          #if k-inpo.contains(pattern){[順不]}
          #(counter("kuran-set-inpo").get().at(0)+1)])] //セット問題や順不同問題には番号をつける
          }
      #if show-answer == 1 {
          place(dx:3%,dy:-84%,box(fill:black,inset:1.5pt,text(fill:red.lighten(60%), weight: 700, size:1.2em, font:mark-font)[#answer]  ))
          } //解答を挿入
    ]
    
    if answer != none {counter("kuran-"+str(num)).update(answer)} //設問番号のカウンターに回答を代入
    
    if label != none {counter("kuran-"+label+"-tx").update(num)} //ラベル用のカウンターに現在の設問番号を代入
    
    if point != none {counter("kuran-"+str(num)+"point").update(point)} //配点記録用設問番号のカウンターに配点を代入
    counter("kuran-"+str(num)+"pattern").update(pattern)
  }
  
  if pattern == 9 or pattern == 8 {counter("kuran-set-inpo").step()} //セット問題や順不同問題が閉じられると番号を増やす
}

///解答を表示するときのみ表示するコンテンツ
/// -> content
#let answer-mode-only(
  ///本文
  ///-> content
  body
  ) = {
  context{if counter("showanswer").get().at(0) == 1 {block(stroke:red,inset:1pt,body)}}
}

//解答欄番号を再利用する場合の設定


///正答・配点表を作成する
///-> content
#let kaitoran(
              ///正答の配列
              ///-> array
              answers,
              ///配点の配列
              ///-> array
              points, 
              ///採点パターンの配列
              ///-> array
              patterns, 
              ///表に解答を表示するかどうか
              ///-> bool
              show-answer,
              ///配点を表示するかどうか
              ///-> bool
              show-point, 
              ///合計点
              ///-> int
              total-points, 
              /// 設問番号のナンバリング方法
              ///-> str
              numbering-style:def-numbering-style,
              ) = {
  context{
    let pattern-search-s = () //順不同 or セット採点始まりの設問番号を配列として取得
    let pattern-search-m = () //順不同 or セット採点の真ん中の設問番号を配列として取得
    let pattern-search-l = () //順不同 or セット採点終わりの設問番号を配列として取得
    let tab = ()
    let total-number = counter("kuran").get().at(0) //kuran命令で作成された設問の数を取得
    for num in range(total-number){
      tab.push([#text(font:mark-font, weight: mark-weight)[#numbering(numbering-style,num+1) ]]) //設問番号
      tab.push([#if show-answer {answers.at(num)}]) //正答
      tab.push(
          [#if show-point {if patterns.at(num) != 2 {[#points.at(num)]} } //セット採点の場合は配点を記入しない
                           #if  patterns.at(num) == 9 {h(1fr)+text(0.5em)[(順不同)]
                              } else if patterns.at(num) == 8 {text(0.5em)[#h(1fr) (セット)]}   //順不同かセット採点なのかを表記          
          ]
        ) //配点
      //順不同やセット採点がどこから始まって，どこで終わるのかを調べる
      if num > 0 and (patterns.at(num)*patterns.at(num -1 ) == 1 or patterns.at(num) * patterns.at(num -1) == 4) {pattern-search-m.push(num)} //中間なら一個前も今も1 あるいは 2であるので積を調べる
      else  if patterns.at(num) == 1 or patterns.at(num) == 2 {pattern-search-s.push(num)} //そうでない，かつ 1 or 2であればセット or 順不同の開始
      if patterns.at(num) == 8 or patterns.at(num) == 9 {pattern-search-l.push(num)}  //8, or 9ならセット or 順不同の終了
    }
    table(
          columns:(auto,1fr,1fr), //列の幅
          //枠を，順不同採点やセット採点の初めはtopだけ，終わりはbottomだけ，真ん中はtopもbottomも枠を書かないようにする．
          stroke: (x,y)=> {
            // x == 2は配点を表示する列
            if x == 2 and pattern-search-m.contains(y - 1) {(left:1pt, right:1pt)} //真ん中
            else if x == 2 and pattern-search-s.contains(y - 1) {(top:1pt, left:1pt, right:1pt)} //初め
            else if x == 2 and pattern-search-l.contains(y - 1) {(left:1pt, right:1pt, bottom:1pt)} //終わり
            else {1pt} //それ以外
            }, 
          align:(center+horizon,horizon+left,left+horizon),
          table.header([設問],[正答],[配点]), //ヘッダー
          ..tab, //設問，正答，配点を記入
          [計],[],[#total-points] //合計点を記入
        )
  }
}

//inlineの参照可能なものは作れないので，特別に作る．
//番号付き下線と番号付き空欄は番号カウンターが共通

///自動連番番号付きの下線を引く．
///
///`Qbox`, `Qparen`と`Qunderline`は番号が共通である．
/// -> content
#let Qunderline(
                  ///参照用ラベル
                  ///-> str
                  label:none,
                  /// 番号のナンバリング方法
                  /// -> str
                  numbering-style:"ア",
                  ///下線をベースラインからいくらずらすかの設定
                  ///-> auto|length
                  offset:auto,
                  ///線の装飾
                  ///-> auto|length|color|gradient|stroke|pattern|dictionary
                  stroke:auto, 
                  ///下線を引かれる文章
                  ///->content
                  body
                  ) = {
  counter("toi").step()
  context{
    text(size:0.7em)[(#numbering(numbering-style,counter("toi").get().at(0)))]+underline(body,offset:offset,stroke:stroke)
    if label != none {
        counter("toi"+label).update(counter("toi").get().at(0))
        counter("toi"+label+"kind").update(1)
    }
  }
}

///自動連番番号付き空欄（ボックス）を作成する．
///
///`Qbox`, `Qparen`と`Qunderline`は番号が共通である．
///-> content
#let Qbox(
           ///参照用ラベル
           ///-> str
           label:none, 
           ///空欄の幅
           ///-> length
           width:2em,
           ///囲み線の装飾
           ///-> auto|length|color|gradient|stroke|pattern|dictionary
           stroke:0.5pt,
           ///番号のナンバリング方法
           ///-> str
           numbering-style:"ア"
           ) = {
  counter("toi").step()
  context[
    #box(height:12pt,width:width, stroke:stroke,baseline: 1pt)[#align(center+horizon)[#text(size:0.8em)[#numbering(numbering-style,counter("toi").get().at(0))]]]
    #if label != none {
        counter("toi"+label).update(counter("toi").get().at(0))
        counter("toi"+label+"kind").update(2) 
      }
  ]
}


///自動連番番号付き空欄（カッコ）を作成する．
///
///`Qbox`, `Qparen`と`Qunderline`は番号が共通である．
///-> content
#let Qparen(
           ///参照用ラベル
           ///-> str
           label:none, 
           ///空欄の幅
           ///-> length
           width:3em,
           ///番号のナンバリング方法
           ///-> str
           numbering-style:"ア"
           ) = {
  counter("toi").step()
  context[（
    #box(height:12pt,width:width, stroke:0pt,baseline: 1pt)[#align(center+horizon)[#text(size:1em)[#numbering(numbering-style,counter("toi").get().at(0))]]]）
    #if label != none {
        counter("toi"+label).update(counter("toi").get().at(0))
        counter("toi"+label+"kind").update(2) 
      }
    ]
}



///`Qbox`, ``Qparenと`Qunderline`のラベルを引用できる．
///下線・欄の参照. 下線か空欄かは自動で判別できるようにする
#let Qref(label,
          numbering-style:"ア",
          kasen:"下線部",
          kuran:"空欄") = {
    context{
      let kind = counter("toi"+label+"kind").get().at(0)
      if kind == 1 {kasen} else if kind == 2 {kuran}
        numbering(numbering-style,counter("toi"+label).get().at(0))
      } 
}

///選択肢ボックスを作成する
///-> content
#let choicebox(
      ///選択肢ボックスの選択肢の配列
      ///-> array
      candidate,
      ///列数
      ///-> int
      row:1, 
      ///縦の大きさ
      ///-> auto|length
      row-size:auto 
      ) = {
  let n = candidate.len() //選択肢数を取得
  let col = (14pt, 1fr)*int(n/row)  //列の幅を計算する
  let narray = () 
  for i in range(n) {
    narray.push(mark-shape(text(size:mark-size,top-edge: 0.7em,)[#numbering("1",i+1)]))
    narray.push(candidate.at(i)) //選択肢を出力
  }
  [#box(stroke:1pt,inset:1em, grid(align:horizon,columns:col,rows:row-size,row-gutter: 1em,..narray))]
}
///選択肢の提示：①〜④までみたいなものを作成する
///-> content
#let choicelist(
  ///選択肢の数
  ///-> int
  n,
  ///開始番号
  ///-> int
  start:1,
  ///
  ///つなぎの記号
  separator:"〜",
) = {
  mark-shape(text(size:mark-size,top-edge: 0.7em,)[#numbering("1",start)])
  [#separator]
  mark-shape(text(size:mark-size,top-edge: 0.7em,)[#numbering("1",start + n - 1)])
}



///設問番号の参照
#let monref(label:none, //参照する設問番号のラベル
          mode:none, //モード: "f"で最終番号, ""で番号なしの欄を出力
          n:1, //指定した番号を出力
          numbering-style:def-numbering-style, //ナンバリング方法
          at:none, //見出しなどにつけたラベルの時点での最新の設問番号を出力する
          stroke:1pt,
          width:kuran-width, //空欄の幅
          add:0, //nやlabelで指定した番号にaddの分だけ数字を足す.
          ) = {
  context{
    let num = {if mode == none and label == none and at == none {n}
                else if at != none {counter("kuran").at(at).at(0)+add}
                else if label != none {counter("kuran-"+label+"-tx").final().at(0)+add}
                else if mode == "f" {counter("kuran").final().at(0)}
                else if mode == "" {}
              }
    kuranbox(
      stroke:stroke,
      width:width)[
        #text(font:mark-font, weight: mark-weight)[
          #if mode != "" {numbering(numbering-style,num) //mode""でなければnumで指定した番号を出力する
        }
      ]
    ] 
  }
}

//自動連番問題. 小問の番号付に用いる. 引数 nameで題を変更できる.
#let mondai(body,
            name:"問題"
            ) = {
  counter("mondai").step()
  block(width:100%)[#context[#strong[#name #numbering("1.",counter("mondai").get().at(0))]
  #body 
  ]]
}


#let help = {
  [#heading(numbering: none)[コマンドヘルプ]
作りかけです.

- ```typst #setmon(answer:整数, point:整数, pattern:整数, numbering-style:文字列)```
    - 問番号の欄 #setmon()を作成する．番号は自動連番される．
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


#let sample-exam = {
  [```typst
#import "lib/template.typ":* //マークシートのテンプレートを読み込む
#import "@preview/cetz:0.3.1" //図を描くためのパッケージ
#import "@preview/rexllent:0.2.3": xlsx-parser //excelの表を取り込む機能

#let 科目 = {
  [科目名]
}
#let 担当教員 = {
  [担当教員名]
}

//以下でマークシート用テンプレートの設定を行う
#show: project.with(
  title:[#科目 期末試験 (#担当教員 担当)],
  N:75, //問題数
  body-font:("New Computer Modern", "Harano Aji Mincho"), //本文フォント//フォントを二つ以上指定している場合，左から順に優先度があり，優先度の高いフォントにない文字が次の優先度のフォントで表示されます．
  sans-font:("New Computer Modern Sans", "Harano Aji Gothic"), //強調フォント
  math-font:("New computer modern math", "Harano Aji Mincho"), //数式フォント
  show-answer:false, //これをtrueにすると解答を問題に出すことができる．
  kaito-title:[#科目　*解答用紙* ], //解答用紙のタイトル
  kaito-ichiran:[#科目 *正答一覧*],
  show-answers-table:true, //正答一覧の正答を表示
  show-points-table:true, //正答一覧の配点を表示
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
#block(setmon(answer:3,point:2)+  choicebox(("アレイ", "牛", "イオン", "たぬき")))
]
//引数answerで正答番号，pointで点数を指定する．
//choiceで選択肢欄を作ることができる．

#answer-mode-only[解答を表示するとき専用のメモ．問題には表示できないメモ書きなどに利用]

#mondai[
 #Qunderline(label:"y")[あいうえお]という．そうすると#Qbox(label:"x")は日本国憲法を発布した．#Qparen()
#Qref("y")と#Qref("x")について，#sentaku 

#block[#setmon(answer:1,point:3)#choicebox(row:2,([$x^2$], $integral_0^1 x^2 dif x$, [xx], [
#lorem(5)
]))
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
  #let newul(label:none,body) = Qunderline(label:none,numbering-style:"A",body)
  //#letを使って命令を新しく作ることができます．この場合は番号の書式を変更して，番号付き下線を新しく定義し直しています．
  #newul[２つの二桁の数字を選んでください]. 空欄や下線部に振る数字・文字は変えることができます．
  
  #setmon(answer:8,point:0,pattern:2)#setmon(answer:1,point:0,pattern:2)
  #setmon(answer:3,point:0,pattern:2)#setmon(answer:9,point:8, pattern:8)
]

```]
}