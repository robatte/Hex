
Crafty.c 'Grid', 
    pos: (q, r, size)->
        @attr
            q: q
            r: r
            x: size * 3 / 2 * q
            y: size * Math.sqrt(3) * (r + q / 2)
        this