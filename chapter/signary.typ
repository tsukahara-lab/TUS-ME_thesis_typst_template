#import "../style/thesis_style.typ": *

#heading([記号表], numbering: none)

#signary-list(title: [Alphabet],
  (
    [ $d$ ]   , [ Channel width [#unit("m", space: none)] ],
    [ $L_j$ ] , [ Computational domainsize in $j$-direction [#unit("m", space: none)] ],
    [ $N_j$ ] , [ Number of grid points in $𝑗$-direction ],
    [ $R e$ ] , [ Reynolds number, $=u d\/nu$ ],
    [ $u$ ]   , [ Velocity [#unit("m/s", space: none)] ],
  )
)
#linebreak()

#signary-list(title: [Greek],
  (
    [ $delta$ ]           , [ Channel half width [#unit("m", space: none)] ],
    [ $epsilon_(i j k)$ ] , [ Levi–Civita symbol ],
    [ $nu$ ]              , [ Kinematic viscosity [#unit("m^2/s", space: none)] ],
  )
)
#linebreak()

#signary-list(title: [Superscripts],
  (
    [ $(quad)^*$ ]          , [ Normalized by outer variables, e.g., $delta$ ],
    [ $(quad)^+$ ]          , [ Normalized by inner variables, e.g., $nu\/u_(tau)$ (wall unit) ],
    [ $(quad)'$ ]           , [ Fluctuation component ],
    [ $overline((quad))$ ]  , [ Statistically averaged ],
  )
)
#linebreak()

#signary-list(title: [Subscripts],
  (
    [ $(quad)_"rms"$ ]      , [ Root mean square ],
    [ $(quad)_upright(w)$ ] , [ Wall ],
    [ $(quad)_tau$ ]        , [ Wall unit ],
  )
)
