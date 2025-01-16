#let choice = 10


#let response = ("0","1","2","3","4","5","6","7","8","9","A","K","P", "S", "E", "T")

#let dummy = ("A","A","A","A","A","A","A")

#let mark = {
  for i in range(choice){
  box[#ellipse(width: 18pt, height: 18pt)[#align(center+horizon,)[#i]] ]+h(10pt)  
}
}

#let def-numbering-style = "1"

#let mark-font = ("Noto Sans CJK JP")
#let mark-size = 8pt
#let mark-height = 10pt
#let mark-widhth = 10pt
#let mark-weight = 500


#let filling(answer, i) = {
    if answer == i {
      return black}
    else {return white}
  }


#let mark_ans(answer, col:black, size:mark-size) = {
  for i in range(choice){
    box[#ellipse(width: mark-widhth, height: mark-height, fill: filling(answer, i), stroke:.5pt+col)[#align(center+horizon,)[#text(size:size, fill: if answer == i {black} else {black})[#i]]] ]+h(5pt)  
  }
}

#let mark_answer(answers, N, numbering-style:def-numbering-style) = {
  let n = answers.len()
  let question = ()
  for i in range(N) {
    question.push(text(font:mark-font, size:10pt, weight:mark-weight)[#numbering(numbering-style,i+1)])
    question.push(mark_ans( if i < n {answers.at(i)} else {}))
  }
  return question
}
#let maru = box[#circle(stroke:4pt, radius: 8pt)]





#let IDs(dummy) = {
let IDs = ()
let num = 7
let rnum = response.len()
for i in range(rnum) {
    IDs.push([#response.at(i)])
  for j in range(num){
    IDs.push(box[#ellipse(width: mark-widhth, height: mark-height, fill: filling(dummy.at(j), response.at(i)), stroke:.5pt)[#align(center+horizon,)[#text(size:mark-size,fill: if dummy.at(j) == response.at(i) {black} else {black},response.at(i))]] ])  
  }  
}
return IDs
}




#let studentID(dummy, response) = {
return table(columns:8,[],align:center+horizon,table.cell(colspan: 7, align:center+horizon)[学籍番号],[#hide[x]],[],[],    [],[],[],[],[],..IDs(dummy),
    stroke: (x,y) => {
    if x == 0 {(left:0pt)}  
    else if y <= 1 {1pt} else if x == 1 {(left:1pt)} else if x == 7 {(right:1pt)} else  {(left:.5pt, right:.5pt)} 
    if y == response.len()+1 and x>=1 {(bottom:1pt)} 
    
    }
  )

}

#let hanrei = table(columns:(23pt,auto),stroke:0pt,[],[#mark_ans("", col:white, size:10pt)])

#let marked-sheet(answers:(), N:60, response:response, dummy:dummy, texts:"") = {

  set page(paper:"a4",flipped: true, margin:(left:0.5cm,right:0.5cm, top:1cm, bottom:1cm), header: [#maru #h(1fr) #text(size:15pt)[#texts] #h(1fr) #maru ], footer: [#maru #h(1fr) #maru ])
  
  grid( columns:(.5cm, auto,auto, auto,auto, .5cm), row-gutter:0pt, column-gutter: 10pt,
  [],[],[#hanrei],[#h(5.8pt)#box(hanrei)],[#h(5.9pt)#box(hanrei)],[],
  [],[#studentID(dummy,response)  #table(align:center+horizon, stroke: (x,y)=>{ if x>= 1 {1pt}}, columns:(18pt,80*1.75pt),[],[氏名],[],[#hide[氏名\ 氏名]])], grid.cell(colspan:3,columns(3, gutter:0pt)[#table(columns:(23pt,auto), align:center+horizon,..mark_answer(answers, N))] ))

}

#let kuranbox(body, x:0) = box(stroke: (thickness:1pt,dash: if x ==0{"solid" }else {"dash"}),width:1.5em, height: 1.2em, )[#align(center+horizon)[#body]]

#let a = ("")*7

#let unmarked-sheet = marked-sheet(dummy:("","","","","","",""),texts:[*解答用紙*])

#let kuran(numbering-style:def-numbering-style, label:none, answer:none, point:none, font:mark-font, pattern:0) = {
  counter("kuran").step()
  context{
    let num = counter("kuran").get().at(0)
    let show-answer = counter("showanswer").get().at(0)
    kuranbox()[#text(font:mark-font, weight: mark-weight)[#numbering(numbering-style,num) ]]+if show-answer == 1 {text(fill:red)[ #answer ]}
    if answer != none {counter("kuran-"+str(num)).update(answer)}
    if label !=none {counter("kuran-"+label+"-tx").update(num)}
    if point != none {counter("kuran-"+str(num)+"point").update(point)}
    counter("kuran-"+str(num)+"pattern").update(pattern)
  }
}

#let refku(numbering-style:def-numbering-style,label, font:mark-font) = {
  context{
  let num = counter("kuran-"+label+"-tx").get().at(0)
  box(setting_kuran,x:1)[#text(font:mark-font, weight: mark-weight)[#numbering(numbering-style,num)]]
  }
}

