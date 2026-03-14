%!TEX TS-program = nv-metapost
%--------------------------------------------------------------
% borders.mp
%   Handy things for creating borders for designs
% Copyright (c) 2026 Dean E. Draayer
%--------------------------------------------------------------
input dedjobdefaults;
input dedmpost;


%----- BORDER BUILDING MACROS -----

%--- full_border_rect_corners(p,w,h) ---
% Return a cycle that's a w x h rectangle with the corners having copies of
% path p spliced in.
vardef full_rect_border_corners(expr p,w,h) =
    save q,Q,v;
    pair q,Q,v;
    path q[];

    q1 = quarter_rect_border_corner(p,w/2,h/2);
    % To get the next quarter: take a copy of 1st quarter, flip it over at the
    % 1st quarter's endpt in the direction it is moving there, reversing the
    % direction of the copy so that things all line up right.
    Q = endpoint q1;
    v = (direction (length q1) of q1) rotated 90; % direction perp to end of q1
    q2 = reverse q1 reflectedabout(Q, Q + v);
    q3 = q1 rotated 180;
    q4 = q2 rotated 180;

    q1 & q2 & q3 & q4 -- cycle
enddef;


%--- quarter_rect_border_corner(p,w,h) ---
% Return a path for a w x h upper-right quarter borer with a shifted
% copy of path p spliced into the corner.
% The path starts at (w,0), moves up to the starting point of the corner path,
% travels the corner path, and continues left out at the endpoint of the corner
% path until it stops a (0,h).
vardef quarter_rect_border_corner(expr p,w,h) =
    save P,Q,R,q,v;
    pair P,Q,R,v;
    path q;

    P = startpoint p;
    Q = endpoint p;
    R = P + whatever*up = Q + whatever*right;
    v = (w, h) - R; % the shift needed to get corner path into place
    q = p shifted v;

    (xpart startpoint q, 0) -- q -- (0, ypart endpoint q)
enddef;


% TODO: A "four quarters" macro
% A quarter border by itself isn't typically that useful on its own.
% It's the full border that is what one usually wants.
% But printing a full border has a few drawbacks:
%   - Lots of wasted, empty paper
%   - The entire border is limited in size to a single sheet of printed paper
% You can get bigger possible full borders while wasting less space by printing
% four quarter borders arranged prudently. E.g.... (include a nextfig for this).
%
% Hint: If you are hollow-drawing quarter borders, use: interim linecap := butt
% This avoids the "last one leaves its mark" artifact.


% TODO: Support for "rails" - the gutters parallel to the main border rectangle
% that fill the space between the corner treatments.


%----- CORNER TREATMENTS -----

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

stop_unless_jobname_is("borders");



%----- SAMPLE FIGURES HERE -----

color shade;
shade := .7white;


nextfig;
    path p;
    p = reverse quartercircle scaled 3/4in rotated 180;
    draw quarter_rect_border_corner(p, 2in, 1in) withpen pencircle scaled 2mm withcolor shade;
    draw bbox currentpicture;
endfig;

nextfig;
    path p;
    p = square_corner_twist(4/16in,3/16in);
    drawhollowed(2mm,1.5mm,shade) full_rect_border_corners(p, 6in, 4in);
    draw bbox currentpicture;
endfig;

taggedfig("Border-QuarterCircDimple-Corners");
    numeric w,h;
    path p;
    w = 10in;
    h = 4in;
    m = 1/4in;
    p := reverse quartercircle scaled 1in rotated 180;
    pickup pencircle scaled 2bp;
    draw full_rect_border_corners(p, w-2m, h-2m) withpen pencircle scaled 2mm;
    p := ucircle scaled 3/16in shifted (w/2-m-1/16in, h/2-m-1/16in);
    filldraw p;
    filldraw flip_vert(p);
    filldraw flip_horiz(p);
    filldraw flip_horiz(flip_vert(p));
    draw usquare xscaled w yscaled h;
endfig;

end.
