//機能の読み込み
#import "functions.typ":*

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
    response:response, //学籍番号の選択肢
    ID_num:7, //学籍番号の桁数
    show-answers-table:true,
    show-points-table:true,
    choice:10, //選択肢数,
    numbering-style:"1",//選択肢のスタイル
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

    //分数の両端にスペースを追加する
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
        #kaitoran(numbering-style:numbering-style,answers, points, patterns, show-answers-table, show-points-table, total-points)]
      }
      
      //解答マークシート
      #marked-sheet(answers:answers, numbering-style:numbering-style, response:response, ID_num:ID_num, dummy:("A")*ID_num, choice:choice,texts:[*正答マークシート*], N:N)
      
      //配点マークシート
      #marked-sheet(answers:points, response:response,dummy:("0")*ID_num, ID_num:ID_num,choice:choice, numbering-style:numbering-style,texts:[ *配点マークシート*  満点: #total-points ], N:N)
      
      //採点パターンマークシート
      #marked-sheet(answers:patterns, response:response, ID_num:ID_num,dummy:("1")*ID_num, choice:choice,numbering-style:numbering-style,texts:[ *採点パターンマークシート* ], N:N)
      ]
      
      //空のマークシート
      marked-sheet(dummy:("XXX")*ID_num,ID_num:ID_num, choice:choice,numbering-style:numbering-style,texts:[#kaito-title], response:response, N:N)
}