%!TEX TS-program = nv-metapost
%--------------------------------------------------------------
% Aint.mp
%   Design for ["Ain't" ain't a word] sign
% Copyright (c) 2025 Dean E. Draayer
%--------------------------------------------------------------
input dedjobdefaults;
input dedmpost;
input chipcarving;

path unotchdmd;
% Unit notched diamond (1 bp tall & wide) with origin at LL corner of bbox
unotchdmd := origin_at_LL(notched_square(.2,.3) scaled (1/sqrt(2)) rotated 45);

% Render an MxN array of notched diamonds, each of width/height d.
% Return a picture of a shaded rectangle of height M*d and width N*d
% filled with a tiling of d-by-d notched diamonds.
vardef chip_motif(expr d, M, N) =
    save tile;
    picture tile;
    interim bboxmargin := 0;
    tile := image(
        fill bbox (unotchdmd scaled d) withcolor shade;
        fill (unotchdmd scaled d) withcolor white;
    );
    tiling_MxN(tile, M, N)
enddef;


%--- FIGURES BEGIN HERE ---

nextfig;
    numeric W, H, w, h, c, m, dw, dh, g, d;
    picture corner_motif;
    color shade;
    shade := .75white;

    e := 2mm;           % width of etched troughs
    H := 4in - 1/16in;  % overall height of the
    W := 7in;
    c := 3/16in;        % outer edge chamfer
    m := 1/8in + e/2;   % margin between edge chamfer & outer trough midline
    d := 7/16in;        % unotchdmd width
    g := 3/16in + e/2;  % corner design margin (between unotchdmd box & trough midline)
    W = w + 2(c + m);   % w x h - width & height of outer trough midline
    H = h + 2(c + m);
    dw = 2g + 1d;       % dw x dh - width & height of trough midline around unotchdmd motif
    dh = 2g + 3d;

    % Prepare corner motif
    corner_motif := origin_at_UR(chip_motif(d, 3, 1));

    % Outer edge & chamfer
    drawfilled(shade) petal(usquare xscaled W yscaled H);
    draw usquare xscaled (W - 2c) yscaled (H - 2c);

    % Etched troughs
    drawoptions(withpen pencircle scaled e withcolor shade);

    % Outer etched trough
    draw usquare xscaled w yscaled h;

    % Corner motif troughs
    path p_;
    p_ := usquare xscaled dw yscaled dh
                  shifted (w/2 - (g + d/2), h/2 - (g + 3d/2));
    draw p_;
    draw flip_horiz(p_);
    drawoptions();

    % Now the unotchdmd motifs
    corner_motif := corner_motif shifted (w/2 - g, h/2 - g);
    draw corner_motif;
    draw flip_horiz(corner_motif);
endfig;

end.
