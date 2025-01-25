#import "@preview/tidy:0.4.0"
#import "template.typ":* //マークシートのテンプレートを読み込む
#import "marksheeters.typ":*

#set text(font: "Noto Sans CJK JP")
未完成

#let docs = tidy.parse-module(
                            read("marksheeters.typ"),
                            name:"Marksheeter",
                            scope:(kuran:kuran, )
                            
                           )
#tidy.show-module(docs, style: tidy.styles.default)