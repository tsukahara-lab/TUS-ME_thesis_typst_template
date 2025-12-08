
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//                        LOCAL FUNCTION
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


#let nonumber = <equate:revoke>

// LATEX character
#let LaTeX = {
  [L]
  box(move(
    dx: -4.2pt,
    dy: -1.2pt,
    box(scale(65%)[A]),
  ))
  box(move(
    dx: -5.7pt,
    dy: 0pt,
    [T],
  ))
  box(move(
    dx: -7.0pt,
    dy: 2.7pt,
    box(scale(100%)[E]),
  ))
  box(move(
    dx: -8.0pt,
    dy: 0pt,
    [X],
  ))
  h(-8.0pt)
}

#let signary-list(title: [], body) = {
  set par(first-line-indent: 0em)
  title
  table(
    columns: (10em, auto),
    stroke: none,
    ..body
  )
}

#let fig(..arg, label: none, placement: auto) = {
  if placement == auto {
    context {
      let heading-page = query(heading.where(level: 1)).map(it => it.location().page())
      let here-page = here().page()
      let heading-here = here-page in heading-page

      let fig-size = measure(figure(..arg)).height
      let interval-size = 297mm - 63mm - fig-size - here().position().y

      text(font: "Adobe Blank")[#hide([A])]

      if heading-here {
        //章の先頭ページのとき

        if fig-size > (297mm - 63mm) / 2 {
          //図がページの半分以上のとき，単一ページとする
          page[
            #set align(center + horizon)
            #figure(
              ..arg,
              placement: none,
            )#label
          ]
        } else {
          if interval-size > 0mm {
            //図を下に配置できるとき，下に配置
            [
              #figure(
                ..arg,
                placement: bottom,
              )#label
            ]
          } else {
            //図を下に配置できないとき，次ページの上に配置
            pagebreak()
            [
              #figure(
                ..arg,
                placement: top,
              )#label
            ]
          }
        }
      } else {
        //章の途中ページのとき

        if fig-size > (297mm - 63mm) / 2 {
          //図がページの半分以上のとき，単一ページとする
          page[
            #set align(center + horizon)
            #figure(
              ..arg,
              placement: none,
            )#label
          ]
        } else {
          //図がページの半分以下のとき，上に配置
          [
            #figure(
              ..arg,
              placement: top,
            )#label
          ]
        }
      }
    }
  } else {
    if placement == top {
      [
        #figure(
          ..arg,
          placement: top,
        )#label
      ]
    } else if placement == bottom {
      [
        #figure(
          ..arg,
          placement: bottom,
        )#label
      ]
    } else {
      page[
        #set align(center + horizon)
        #figure(
          ..arg,
          placement: none,
        )#label
      ]
    }
  }
}

// 学位論文用の表作成関数
#let tblr(
  ..body,
  columns: auto,
  rows: auto,
  gutter: auto,
  column-gutter: auto,
  row-gutter: auto,
  align: auto,
  fill: none,
  stroke: auto,
  inset: 0% + 5pt,
) = {
  let output-array = body.pos()

  let frame(stroke) = (x, y) => (
    left: if x > 0 { stroke } else { none },
    right: none,
    top: if y == 0 or y == 1 { stroke } else { 0pt },
    bottom: black + 0.5pt,
  )

  let stroke-out = stroke
  if stroke-out == auto {
    stroke-out = frame(black + 0.5pt)
  }

  let row-gutter-out = row-gutter
  if row-gutter-out == auto {
    row-gutter-out = (2pt, auto)
  }

  output-array.insert(0, table.cell(colspan: columns, inset: 0pt)[])

  table(..output-array, columns: columns, stroke: stroke-out, fill: fill, gutter: gutter, column-gutter: column-gutter, row-gutter: (
      2pt,
      auto,
    ), inset: inset, align: align)
}

// 無次元数の設定

#let Ar = $A r$
#let As = $A s$
#let Be = $B e$
#let Bm = $B m$
#let Bi = $B i$
#let Bo = $B o$
#let Br = $B r$
#let Ca = $C a$
#let Da = $D a$
#let Cf = $C_f$
#let Cl = $C_l$
#let Cd = $C_d$
#let Cp = $C_p$
#let De = $D e$
#let Ec = $E c$
#let Ek = $E k$
#let Er = $E r$
#let Eu = $E u$
#let Fr = $F r$
#let Ga = $G a$
#let Gz = $G z$
#let Gr = $G r$
#let Ha = $H a$
#let Hg = $H g$
#let Ir = $I r$
#let Ka = $K a$
#let Kn = $K n$
#let Ku = $K u$
#let La = $L a$
#let Le = $L e$
#let Ma = $M a$
#let Mg = $M g$
#let Mo = $M o$
#let Nu = $N u$
#let Oh = $O h$
#let Pe = $P e$
#let Pr = $P r$
#let Ra = $R a$
#let Re = $R e$
#let Ri = $R i$
#let Ro = $R o$
#let Sc = $S c$
#let Sh = $S h$
#let St = $S t$
#let Stk = $St_k$
#let Ta = $T a$
#let Wea = $W e a$
#let We = $W e$
#let Wi = $W i$
