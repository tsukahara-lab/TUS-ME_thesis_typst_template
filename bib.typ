#import "style/thesis_style.typ": *
#import "bib_style/bib_style.typ": *
#set figure(placement: none)

#bibliography-list(
  bib-tex[
  @article{Reynolds:PhilTransRoySoc1883,
        author  = {Reynolds, Osborne},
        title   = {An experimental investigation of the circumstances which determine whether the motion of water shall be direct or sinuous, and of the law of resistance in parallel channels},
        journal = {Philosophical Transactions of the Royal Society of London},
        volume  = {174},
        number  = {},
        pages   = {935--982},
        year    = {1883},
        doi     = {10.1098/rstl.1883.0029},
        url     = {https://royalsocietypublishing.org/doi/abs/10.1098/rstl.1883.0029}
    }
  ],
  // ここから日本語文献 //
  bib-tex[
    @article{塚原:ながれ2023,
        author  = {塚原, 隆裕},
        yomi    = {Tsukahara, Takahiro},
        title   = {私の「ながれを学ぶ」使命感},
        journal = {ながれ：日本流体力学会誌},
        volume  = {42},
        number  = {3},
        pages   = {222},
        year    = {2023},
        url     = {https://www.nagare.or.jp/publication/nagare/archive/2023/3.html}
    }
  ]
)
