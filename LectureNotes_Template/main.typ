#import "template.typ":*
#import "@preview/cetz:0.3.4"



  
// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title:[講義ノート],
  short-title:[ショートタイトル],
  authors:(
    "著者",
    //"another author",
  ),
  notes:([著者詳細],),
  date:"",
  mode:true //falseで通常のレイアウト//trueで余白をノートにする
)

= #lorem(4)

#lorem(30)

$
x
$
#lorem(30)

$
x
$<eq>
#lorem(30)
@eq 

#lorem(30)
#npeq[$x$]
#lorem(30)