%!TEX TS-program = nv-metapost
%--------------------------------------------------------------
% Coaster-FloralPetals4.mp
% Copyright (c) 2026 Dean E. Draayer
%--------------------------------------------------------------
input dedjobdefaults;
input dedmpost;
input chipcarving;

color shade;
shade := .5white;


%--- corner_motif(d,g,L,l) ---
% Construct the motif that fills the corners of the coaster.
% Return a picture with dimple at origin and side petals right & up.
%   d - dimple diameter
%   g - gap between dimple and petals
%   L - length of side petals
%   l - length of middle petal
vardef corner_motif (expr d,g,L,l) =
    save s;
    numeric s;
    s = d/2 + g;
    image(
        drawfilled(shade) ucircle scaled d;
        drawfilled(shade) divot_chip(s*right, (s + L/2)*right, d);
        drawfilled(shade) divot_chip(s*dir(45), (s + l/2)*dir(45), 1*d);
        drawfilled(shade) divot_chip(s*up, (s + L/2)*up, d);
    )
enddef;


%--- FIGURES START HERE ---

nextfig;
    path petal, arc;
    picture corner_pic,petalpic,petals_pic,petals_layer;
    numeric W,R,m,g;

    W = 100mm;
    m = 6mm;
    g = 5mm;
    b = 6mm;
    W = 2m + 2g + 2R;

    N = 16;
    N*a = 360;

    % Base petal
    petal = divot(R, .4R) rotated 90 shifted (R/2*up);

    % One "branch" of petals
    petals_pic := image(
        drawfilled(white) petal;
        drawfilled(shade) petal yscaled .82 xscaled .66;
        drawfilled(white) petal yscaled .66 xscaled .43;
        drawfilled(shade) petal yscaled .47 xscaled .16;
    );

    % Four petal branches
    petals_layer := image(
        for i = 0 upto 3:
            draw petals_pic rotated (i*90);
        endfor;
    );

    % Frame
    drawfilled(white) rounded_rect(W, W, m);
    % Mug circles
    draw fullcircle scaled (2R + 2g) withpen pencircle scaled 1.5mm withcolor shade;
    drawfilled(shade) fullcircle scaled 2R;

    for s = 3, 1, 2, 0:
        draw petals_layer rotated (s*a);
    endfor;

    % Button (if you want it)
    drawfilled(white) ucircle scaled b;

    % Corner motif
    corner_pic = corner_motif(4mm,2mm,42mm,21mm) shifted ((W/2-m)*(-1,-1));
    for i = 0 upto 3:
        draw corner_pic rotated (90i);
    endfor;

    % Two copies fit nicely on a printed page - shift a duplicate
    % NB: I'm getting a problem at this point - the bottom edge of bottom design
    % is gone - it's getting cut off. So I'll draw the bounding box (which has a
    % 2bp padding by default) using background color (so it doesn't show).
    draw currentpicture shifted ((W + 1in)*up);
    draw bbox currentpicture withcolor background;
endfig;

end.
