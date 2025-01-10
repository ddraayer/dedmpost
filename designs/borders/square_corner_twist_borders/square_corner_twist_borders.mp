%!TEX TS-program = nv-metapost
%--------------------------------------------------------------
% square_corner_twist_borders.mp
% Copyright (c) 2025 Dean E. Draayer
%--------------------------------------------------------------
input dedjobdefaults;
input dedmpost;

%--- square_corner_twist(s,g) ---
% Return a path for the "lower left" twisted square corner:
%      Q
%      ◀━━━━━━━┓
%     g        ┃
%      ┏━━━━━━━━━━━┓
%      ┃       ┃   ┃
%     s┃       ┃   ┃
%      ┃       ┃   ┃
%      ┗━━━━━━━┛   ▲P
%     O    s     g
%
%  - s is the length of the sides of the square
%  - g is the width of the gap between the square and the "handles"
%  - the corner point is at the origin O
%  - it starts at point P=(s+g,0) on the x-axis moving upward
%  - it ends at point Q=(0,s+g) on the y-axis moving leftward
%
vardef square_corner_twist (expr s, g) =
    save P;
    pair P[];

    P1 = (s + g, 0);
    P2 = (s + g, s);
    P3 = (0, s);
    P4 = (0, 0);
    P5 = (s, 0);
    P6 = (s, s + g);
    P7 = (0, s + g);

    P1 for i = 2 upto 7: -- P[i] endfor
enddef;

%--- square_corner_twist_border_UR(w,h,s,g) ---
% Return a path for the upper right quarter of a full border:
%    Q                       g   s  C
%    ◀━━━━━━━━━━━━━━━━━━━━━━┓  ┏━━━┓
%    △                      ┃  ┃   ┃s
%    │                      ┗━━━━━━┛
%    │                         ┗━━━┓
%   h│                             ┃
%    │                             ┃
%    │                             ┃
%    └────────────────────────────▷▲P
%   O               w
%
%  - the upper right corner is C=(w,h)
%  - it starts at P=(w,0) and ends at Q=(0,h)
%
vardef square_corner_twist_border_UR (expr w, h, s, g) =
    save p;
    path p[];

    p2 = reverse (square_corner_twist(s, g) rotated 180 shifted (w, h));
    p1 = (w, 0) -- (point 0 of p2);
    p3 = (point infinity of p2) -- (0, h);

    p1 & p2 & p3
enddef;

%--- square_corner_twist_border(w,h,s,g) ---
% Return a cycle for a complete four-cornered border
vardef square_corner_twist_border (expr w, h, s, g) =
    save p;
    path p[];

    p1 := square_corner_twist_border_UR(.5w, .5h, s, g);
    p2 := reverse flip_horiz(p1);
    p3 := p1 rotated 180;
    p4 := p2 rotated 180;

    p1 & p2 & p3 & p4 -- cycle
enddef;

stop_unless_jobname_is("square_corner_twist_borders");


%----- FIGURES BEGIN HERE -----

nextfig;
    % Draw a full 4-cornered border
    numeric W, H, s, g;
    H := 4in;
    W := 10in;
    s := 1/4in;
    g := 3/16in;
    e := 2mm;
    drawoptions(withpen pencircle scaled e withcolor .7white);
    draw square_corner_twist_border(W, H, s, g);
endfig;

nextfig;
    % Draw four staggered copies of a quarter of a full border
    numeric W, H, s, g;
    path p;

    H := 4in;
    W := 9in;
    s := 1/4in;
    g := 3/16in;
    e := 2mm;

    p = square_corner_twist_border_UR(W, H, s, g);
    drawoptions(withpen pencircle scaled e withcolor .7white);
    for i = 0 upto 3:
        draw p shifted (i * (s + g, s + g));
    endfor;
endfig;

nextfig;
    % Draw a framed 4-cornered border approx 11in x 6in with chamfered edge
    numeric W, H, w, h, c, m, s, g;
    H := 6in - 1/16in;
    W := 11.5in;
    c := 1/8in;
    m := 3/16in;
    s := 5/16in;
    g := 3/16in;
    e := 2mm;
    W = w + 2(c + m);
    H = h + 2(c + m);
    draw usquare xscaled W yscaled H;
    draw usquare xscaled (W - 2c) yscaled (H - 2c);
    drawoptions(withpen pencircle scaled e withcolor .7white);
    draw square_corner_twist_border(w, h, s, g);
    % guidelines
    drawoptions(withpen pencircle scaled 1pt withcolor .85white dashed evenly);
    draw (-W/2, 0)--(W/2, 0);
    draw (0, -H/2)--(0, H/2);
    draw usquare xscaled (w - 2(s + g)) yscaled (h - 2(s + g))
endfig;

nextfig;
    % Draw a framed 4-cornered border approx 12in x 6in
    numeric W, H, w, h, c, m, s, g;
    H := 6in - 1/16in;
    W := 11.75in;
    c := 0in;
    m := 1/4in;
    s := 5/16in;
    g := 3/16in;
    e := 2mm;
    W = w + 2(c + m);
    H = h + 2(c + m);
    draw usquare xscaled W yscaled H;
    draw usquare xscaled (W - 2c) yscaled (H - 2c);
    drawoptions(withpen pencircle scaled e withcolor .7white);
    draw square_corner_twist_border(w, h, s, g);
endfig;

nextfig;
    % Draw a framed 4-cornered border approx 12in x 6in with "rails" inside
    numeric W, H, w, h, c, m, s, g;
    pair P;
    path p;
    %--- Design parameters ---
    H := 6in - 1/16in;
    W := 11.75in;
    c := 0in;
    m := 1/4in;
    s := 5/16in;
    g := 3/16in;
    e := 2mm;
    W = w + 2(c + m);
    H = h + 2(c + m);
    draw usquare xscaled W yscaled H;
    draw usquare xscaled (W - 2c) yscaled (H - 2c);
    drawoptions(withpen pencircle scaled e withcolor .7white);
    draw square_corner_twist_border(w, h, s, g);
    %--- Draw "rails" inside the border ---
    % Vertical rails here
    P := (w/2 - s, h/2 - (s + g + s));
    p := (flip_vert P)--P;
    draw p;
    draw flip_horiz(p);
    % Horizontal rails here
    P := (w/2 - (s + g + s), h/2 - s);
    p := (flip_horiz P)--P;
    draw p;
    draw flip_vert(p);
endfig;

end.
