%!TEX TS-program = nv-metapost
%--------------------------------------------------------------
% EternalKnot.mp (from 2011-Mar-24)
% Copyright (c) 2025 Dean E. Draayer
%--------------------------------------------------------------
input dedjobdefaults;
input dedmpost;

%--- CONVENIENT DIRECTIONS ---
pair NN, EE, SS, WW, NE, NW, SW, SE;
EE = dir(0);
NN = dir(90);
WW = dir(180);
SS = dir(270);
NE = dir(45);
NW = dir(45+90);
SW = dir(45+180);
SE = dir(45+270);


path axis, seg[];

%-- The knot's medial axis (in bp units)
axis := (0,0)
    -- ( 3, 3){NE} .. {SE}( 5, 3) .. {SW}( 5, 1)
    -- (-1,-5){SW} .. {EE}( 0,-7) .. {NW}( 1,-5)
    -- (-5, 1){NW} .. {SE}(-3, 3)
    -- ( 3,-3){SE} .. {NW}( 5,-1)
    -- (-1, 5){NW} .. {EE}( 0, 7) .. {SW}( 1, 5)
    -- (-5,-1){SW} .. {NE}(-3,-3)
    -- cycle;

%-- The knot segments (in bp units)
% Even-numbered indices are overcrossings, odds go under
seg[ 1] = (-1,-1) -- ( 1, 1);
seg[ 2] = ( 1, 1) -- ( 3, 3){NE} .. {SE}( 5, 3);
seg[ 3] = ( 5, 3){SE} .. {SW}( 5, 1) -- ( 3,-1);
seg[ 4] = ( 3,-1) -- ( 1,-3);
seg[ 5] = ( 1,-3) -- (-1,-5){SW} .. {EE}( 0,-7);
seg[ 6] = ( 0,-7){EE} .. {NW}( 1,-5) -- (-1,-3);
seg[ 7] = (-1,-3) -- (-3,-1);
seg[ 8] = (-3,-1) -- (-5, 1){NW} .. {NE}(-5, 3);
seg[ 9] = (-5, 3){NE} .. {SE}(-3, 3) -- (-1, 1);
seg[10] = (-1, 1) -- ( 1,-1);
seg[11] = ( 1,-1) -- ( 3,-3){SE} .. {NE}( 5,-3);
seg[12] = ( 5,-3){NE} .. {NW}( 5,-1) -- ( 3, 1);
seg[13] = ( 3, 1) -- ( 1, 3);
seg[14] = ( 1, 3) -- (-1, 5){NW} .. {EE}( 0, 7);
seg[15] = ( 0, 7){EE} .. {SW}( 1, 5) -- (-1, 3);
seg[16] = (-1, 3) -- (-3, 1);
seg[17] = (-3, 1) -- (-5,-1){SW} .. {SE}(-5,-3);
seg[18] = (-5,-3){SE} .. {NE}(-3,-3) -- (-1,-1);


%-- Just the knot's medial axis and the grid points --
taggedfig("AxisGrid");
    numeric u;
    u = 1cm;

    % Draw grid points
    pickup pencircle scaled 3bp;
    for i = -6 upto 6:
        for j = -8 upto 8:
            draw (i,j) scaled u withcolor .7white;
        endfor;
    endfor;

    % Draw medial axis
    pickup pencircle scaled 1bp;
    draw axis scaled u;

    % Label some points
    dotlabel.bot("O", origin);
    dotlabel.top("(0,7)", (0,7u));
    dotlabel.bot("(0,-7)", (0,-7u));
    dotlabel.urt("(5,3)", (5u,3u));
    dotlabel.lrt("(5,-3)", (5u,-3u));
    dotlabel.ulft("(-5,3)", (-5u,3u));
    dotlabel.llft("(-5,-3)", (-5u,-3u));
    % Run numbers along left and bottom sides
    for i = -7 upto 7:
        label.lft(decimal(i), (-6u,i*u));
    endfor;
    for i = -5 upto 5:
        label.bot(decimal(i), (i*u,-8u));
    endfor;
endfig;


%-- Eternal knot rendered within an oval frame --
taggedfig("OvalFrame");
    numeric u, W, H, bw, ew, m, pad;

    m = 5mm;            % frame width ("margin")
    pad = 8mm;          % padding between knot & frame
    ew := 1.2bp;        % stroke width of knot ("edge width")
    W = 100mm;          % overall width
%   H = whatever;       % overall height
%   u = whatever;       % design grid unit

    bw = u*sqrt(2);     % band width (knot ribbon excluding edges)
    W = 12u + bw + 2pad + 2m;
    H = 14u + bw + 2pad + 2m;

    fill ucircle xscaled (W - 2m) yscaled (H - 2m) withcolor .8white;
    hollowstroke(ucircle xscaled (W-m) yscaled (H-m), m+2ew, m);

    interim linecap := butt;
    for i = 1 step 2 until 17:
        hollowstroke(seg[i] scaled u, bw + 2ew, bw);
    endfor;
    for i = 2 step 2 until 18:
        hollowstroke(seg[i] scaled u, bw + 2ew, bw);
    endfor;
endfig;


%-- Eternal knot rendered within a diamond frame --
taggedfig("DiamondFrame");
    numeric u, W, H, bw, ew, m, pad;

    m = 5mm;            % frame rail width ("margin")
    pad = 8mm;          % padding between knot & frame
    ew := 1.2bp;        % edge width
    W = 98mm*sqrt(2);   % overall width
%   H = whatever;       % overall height
%   u = whatever;       % design grid unit

    bw = u*sqrt(2);     % band width (knot ribbon excluding edges)
    W = H;
    H = 14u + bw + sqrt(2)*(2pad + 2m);

    fill udiamond xscaled (W - 2m) yscaled (H - 2m) withcolor .8white;
    hollowstroke(udiamond xscaled (W-m) yscaled (H-m), m+2ew, m);

    interim linecap := butt;
    for i = 1 step 2 until 17:
        hollowstroke(seg[i] scaled u, bw + 2ew, bw);
    endfor;
    for i = 2 step 2 until 18:
        hollowstroke(seg[i] scaled u, bw + 2ew, bw);
    endfor;
endfig;
end.
