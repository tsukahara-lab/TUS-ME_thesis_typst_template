#import "../style/thesis_style.typ": *
#set figure(placement: none)

#bibliography-list(
  title: [文献],
  bib-full: false,
  ..bib-file(read("ref.bib"))
)
