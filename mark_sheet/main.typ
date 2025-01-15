#import "lib/functions.typ":*


#let N = 50
#let choice = 10

#let mark = {
  for i in range(choice){
  box[#ellipse(width: 18pt, height: 18pt)[#align(center+horizon,)[#i]] ]+h(10pt)  
}
}


#let question = ()
#for i in range(N) {
question.push("問"+str(i+1)) 
question.push(mark)
}

#let filling(answer, i) = {
    if answer == i {
      return black}
    else {return white}
  }

#let answers = ()//(0,2,6,7,2,2,8,1,9,3)

#let mark_ans(answer) = {
  for i in range(choice){
    box[#ellipse(width: 10pt, height: 10pt, fill: filling(answer, i), stroke:.5pt)[#align(center+horizon,)[#i]] ]+h(10pt)  
  }
}

#let mark_answer(answers, N) = {
  let n = answers.len()
  let question = ()
  for i in range(N) {
    question.push("問"+str(i+1))
    question.push(mark_ans( if i < n {answers.at(i)} else {}))
  }
  return question
}
#let maru = box[#circle(stroke:4pt, radius: 8pt)]



#let response = ("0","1","2","3","4","5","6","7","8","9","A","K","P", "S", "E")

#let dummy = ("A","A","A","A","A","A","A")

#let IDs(dummy) = {
let IDs = ()
let num = 7
let rnum = response.len()
for i in range(rnum) {
  for j in range(num){
    IDs.push(box[#ellipse(width: 10pt, height: 10pt, fill: filling(dummy.at(j), response.at(i)), stroke:.5pt)[#align(center+horizon,)[#response.at(i)]] ])  
  }  
}
return IDs
}




#let studentID = {
  table(columns:7,table.cell(colspan: 7, align:center)[学籍番号],[#hide[x]],[],[],[],[],[],[],..IDs(dummy),
stroke: (x,y) => {if y <= 0 {1pt} else if x == 0 {(left:1pt)} else if x == 6 {(right:1pt)} else  {(left:.5pt, right:.5pt)} 
if y == response.len()+1 {(bottom:1pt)} 
if y == 1 {(bottom:0.5pt)}
}
)
}

#set page(paper:"a4",flipped: true, margin:1.5cm, header: [#maru #h(1fr) #maru ], footer: [#maru #h(1fr) #maru ])

#grid( columns:(1cm, auto,auto, 1cm), row-gutter:10pt, column-gutter: 10pt, [],[#studentID #table(align:center,columns:(5cm),[氏名],[#hide[氏名\ 氏名]])], columns[#table(columns:(40pt,auto), ..mark_answer(answers, N))] )

