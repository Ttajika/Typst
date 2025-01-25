//機能の読み込み
#import "marksheeters.typ":*

//テンプレートの設定
#let project(
    title:[],
    N:75, //設問数
    body-font:("Liberation Serif", "Harano Aji Mincho"), //本文フォント
    sans-font:("Liberation Sans", "Harano Aji Gothic"), //セリフなしフォント
    math-font:("New computer modern math", "Harano Aji Mincho"), //数式フォント
    mono-font:("Liberation mono", "Harano Aji Gothic"), //コード用フォント
    show-answer:false, //解答を表示するかどうか
    kaito-title:[*解答用紙*], //解答用紙のタイトル
    kaito-ichiran:[*正答一覧*], //正答一覧のタイトル
    response:response, //学籍番号の選択肢
    ID_num:7, //学籍番号の桁数
    show-answers-table:true, //正答一覧の正答を表示するかどうか
    show-points-table:true, //正答一覧の配点を表示するかどうか
    choice:10, //選択肢数,
    numbering-style:"1",//選択肢のスタイル
    body //本文
    ) = {
    for i in range(N) {
      counter("kuran-"+str(i+1)).update(1000)
        } //正答のデフォルトを１０００にすることで，kuran命令で更新しない限り正答マークシートに何もマークしないようにする.
    set page("a4", margin:1cm, numbering: "1") //ページ設定
    set text(size:12pt,font:body-font, lang:"ja") //地の文のフォント設定
    set par(first-line-indent: 1em, justify: true) //段落設定
    show strong: set text(font:sans-font,weight: 500) //強調のフォント設定
    show heading: set text(font:sans-font,weight: 500) //見出しのフォント設定
    show math.equation: set text(font:math-font) //数式フォント設定
    show raw: set text(font:mono-font) //コード用フォントの設定
    if show-answer {counter("showanswer").update(1)} //解答を見せるモードにするためにカウンターをアップデート

    align(center,text(2em,strong(title)))

    //分数の両端にスペースを追加する
    //参照：https://forum.typst.app/t/how-to-redefine-the-default-frac-behavior-while-avoiding-circular-references/2195?u=matunaga_touma
    let AddSpacefrac(num, den) = math.frac(
      [#h(1em /6) #num #h(1em /6)],
      [#h(1em /6) #den #h(1em /6)],
      )
    show math.frac: it => {
      if it.has("label") and it.label == <stop-frac-recursion> {
        it
      } else {
        [#AddSpacefrac(it.num, it.denom) <stop-frac-recursion> ]
      }
    }
    //

    
    //本文
    body

    //正答・配点・採点パターンを集計する
    context[
      #let total-points = 0 
      #let answers = ()
      #let points = ()
      #let patterns = ()
      #for i in range(N) {
        answers.push(counter("kuran-"+str(i+1)).get().at(0))　//正答の配列を作成
        points.push(counter("kuran-"+str(i+1)+"point").get().at(0)) //配点の配列を作成
        total-points += counter("kuran-"+str(i+1)+"point").get().at(0) //合計点を計算
        patterns.push(counter("kuran-"+str(i+1)+"pattern").get().at(0)) //採点パターンの配列を作成
      }
      
      #pagebreak() 
      //解答及び配点一覧
      #if show-answers-table or show-points-table {
        heading(numbering: none)[#kaito-ichiran]

        columns(3)[
          #kaitoran(numbering-style:numbering-style,
                    answers, 
                    points, 
                    patterns, 
                    show-answers-table, 
                    show-points-table, 
                    total-points)
          ]
      }
      
      //解答マークシートを作成
      #marked-sheet(answers:answers, numbering-style:numbering-style, response:response, ID_num:ID_num, dummy:("A")*ID_num, choice:choice,texts:[*正答マークシート*], N:N)
      
      //配点マークシートを作成
      #marked-sheet(answers:points, response:response,dummy:("0")*ID_num, ID_num:ID_num,choice:choice, numbering-style:numbering-style,texts:[ *配点マークシート*  満点: #total-points ], N:N)
      
      //採点パターンマークシートを作成
      #marked-sheet(answers:patterns, response:response, ID_num:ID_num,dummy:("1")*ID_num, choice:choice,numbering-style:numbering-style,texts:[ *採点パターンマークシート* ], N:N)
      ]
      
      //空のマークシート（解答用紙）
      marked-sheet(dummy:("XXX")*ID_num,ID_num:ID_num, choice:choice,numbering-style:numbering-style,texts:[#kaito-title], response:response, N:N)

}