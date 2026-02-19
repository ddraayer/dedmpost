%!TEX TS-program = nv-metapost
%--------------------------------------------------------------
% chipcarving.mp
%   Pattern pieces common in chip carving designs
% Copyright (c) 2026 Dean E. Draayer
%--------------------------------------------------------------
input dedjobdefaults;
input dedmpost;


%--- notched_edge(g,h) ---
% Return a line segment with a triangular notch in the middle.
% The segment starts at O=(0,0) and ends at P=(1,0).
% The "gap" width of the notch is g (0<=g<=1), the height of the notch is h.
% (The notch vertex is at (0,h); the notch goes downward if h<0.)
%                 ______
%               ╱╲    △
%              ╱  ╲   │h
%             ╱    ╲  │
%     O______╱      ╲______P
%            ◁───g──▷
vardef notched_edge (expr g,h) =
    save P;
    pair P[];

    P0 = (0, 0);
    P1 = (1/2 - g/2, 0);
    P2 = (1/2, h);
    P3 = (1/2 + g/2, 0);
    P4 = (1, 0);

    P0 -- P1 -- P2 -- P3 -- P4
enddef;


%--- notched_square (g,h) ---
% Return a square with notches in each side. The returned path is essentially
% just a usquare with each of its sides replaced with notched_edge(g,h).
vardef notched_square (expr g,h) =
    save p;
    path p[];

    p1 = notched_edge(g,h);
    p2 = p1 rotated 90 shifted right;
    p3 = p1 rotated 180 shifted right shifted up;
    p4 = p1 rotated 270 shifted up;
    p0 = p1 & p2 & p3 & p4 -- cycle;

    origin_at_center(p0)
enddef;


%--- segmented_oval(w,h,n) ---
% Return a picture of an oval of width w and height h having n segments
% radiating from the center (origin) evenly spaced by arclength.
vardef segmented_oval (expr w, h, n) =
    save i,o,p;
    numeric i;
    path o,p;

    o = ucircle xscaled w yscaled h;
    p = polysegmented(o,n);
    image(
        for i = 0 upto length(p)-1:
            draw origin -- point i of p;
        endfor;
        draw o;
    )
enddef;


%--- divot(l,t) ---
% Return a cycle for a divot of length l and thickness t.
% The axis of the divot is (-l/2,0)--(l/2,0).
vardef divot (expr l,t) =
    save c,p;
    numeric c;
    path p;
    c := 2; % curl parameter at divot ends
    p := (-l/2, 0){curl c} .. (0, -t/2) .. {curl c}(l/2, 0);
    p -- (p rotated 180) -- cycle
enddef;

%--- divot_chip(P,Q,w) ---
% Return a cycle for a divot with endpoints P and Q and width w.
% It includes the axis of the divot [P,Q].
vardef divot_chip (expr P,Q,w) =
    save c,n,M;
    numeric c;
    pair n,M;
    c := 2; % curl parameter at divot ends
    M = 1/2[P,Q];
    n = w/2 * unitvector (Q - P) rotated 90;
    P -- Q{curl 2} .. (M + n) .. {curl 2}P -- Q{curl 2} .. (M - n) .. {curl 2}cycle
enddef;


%----- Ramps -----
% rampslopecoef is a factor that adjusts the direction at which the inclined
% side of a ramp meets the vertices. A value of 1 gives a straight-line incline;
% a value of 0 bends the incline to approach tangentially.
newinternal numeric rampslopecoef;
rampslopecoef:=1;

%--- ramp(w,h) ---
% Return a cycle for a ramp of width w and height h.
% The vertices are (0,0), (w,0), (0,h).
vardef ramp (expr w,h) =
    (0,0) --
    (w,0){(-w,h*rampslopecoef)} ...
    {(-w*rampslopecoef,h)}(0,h) --
    cycle
enddef;

%--- doubleramp(w,h) ---
% Return a cycle for back-to-back ramps of overall width w and height h
% The vertices are (0,0), (w/2,0), (0,h), (-w/2,0).
vardef doubleramp (expr w,h) =
    save p; path p;
    p = ramp(w/2,h);
    p--(flip_horiz p)--cycle
enddef;

stop_unless_jobname_is("chipcarving");


%----- SAMPLE FIGURES HERE -----

pickup pencircle scaled 1bp;

% Notched edges
nextfig;
    draw notched_edge(.2, .5) scaled 3in shifted (0*down);
    draw notched_edge(.6, -.2) scaled 3in shifted (2mm*down);
endfig;

% Notched squares
nextfig;
    draw notched_square(.3, -.4) scaled .5in shifted (1in*left);
    draw notched_square(.5, .2) scaled 1in shifted (.5*right);
    draw notched_square(.2, .3) scaled (1in/sqrt(2)) rotated 45 shifted (1in*right);
endfig;

% A segmented oval
nextfig;
    draw segmented_oval(5in, 2in, 24);
endfig;

% Ramps & double ramps
nextfig;
    numeric i, rsc;
    i:=0;
    for rsc = 1.5, 1.0, 0.5, 0.25, 0.0:
        interim rampslopecoef:=rsc;
        draw ramp(3cm, 1cm) shifted (7cm*left) shifted (1.5i*cm*down);
        draw doubleramp(6cm, 1cm) shifted (1.5i*cm*down);
        i:=i+1;
    endfor;
endfig;

end.
