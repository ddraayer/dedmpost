%!TEX TS-program = nv-metapost
%--------------------------------------------------------------
% graphpaper.mp
% Copyright (c) 2025 Dean E. Draayer
%--------------------------------------------------------------
% Generate graph paper. Supports the following features:
%   - Major horizontal and/or vertical gridlines
%   - Minor horizontal and/or vertical gridlines
%   - Diagonal gridlines
%   - Border around the whole thing
%
% For each of these four categories, one can separately configure:
%   - Size and shape of pen to use
%   - Line color
%
% Typical variations that one can configure:
%   - Horizontal and vertical ranges (xMin, xMax, yMin, yMax)
%   - Size of the major grid cells (Dx, Dy)
%   - Size of the minor grid cells (dx, dy)
%
% Rendering is accomplished by the following drawing macros:
%   - drawGridDiagonals
%   - drawGridMinorHoriz
%   - drawGridMinorVert
%   - drawGridMajorHoriz
%   - drawGridMajorVert
%   - drawBorder
% They should be called in the order listed (to get layering right).
% Include calls for only the parts that you want.
%--------------------------------------------------------------
input dedjobdefaults;
input dedmpost;


%--- GRID STYLE PARAMETERS ---
pen gridpenmajor, gridpenminor, gridpendiag, gridpenborder;
color gridlinecolormajor, gridlinecolorminor,
      gridlinecolordiag, gridlinecolorborder;

gridpenmajor = pencircle scaled .75pt;
gridpenminor = pencircle scaled .5pt;
gridpendiag = pencircle scaled .4pt;
gridpenborder = pencircle scaled 1pt;

gridlinecolormajor = .6white;
gridlinecolorminor = .75white;
gridlinecolordiag = .85white;
gridlinecolorborder = .2white;


%--- GRID RANGES & STEP SIZES ---
numeric xMin, xMax, dx, Dx;
numeric yMin, yMax, dy, Dy;

xMin=0in;
xMax=7.0in;
yMin=0in;
yMax=10.0in;
Dx=1in;
Dy=1in;
dx=.25in;
dy=.25in;


%--- GRID DRAWING ROUTINES ---

vardef drawBorder =
    draw unitsquare xscaled xMax yscaled yMax
        withpen gridpenborder withcolor gridlinecolorborder;
enddef;

vardef drawGridMajorVert =
    save x;
    for x = xMin step Dx until xMax + Dx/2:
        draw (x,yMin)--(x,yMax)
            withpen gridpenmajor withcolor gridlinecolormajor;
    endfor;
enddef;

vardef drawGridMinorVert =
    save x;
    for x = xMin step dx until xMax + dx/2:
        draw (x,yMin)--(x,yMax)
            withpen gridpenminor withcolor gridlinecolorminor;
    endfor;
enddef;

vardef drawGridMajorHoriz =
    save y;
    for y = yMin step Dy until yMax + Dy/2:
        draw (xMin,y)--(xMax,y)
            withpen gridpenmajor withcolor gridlinecolormajor;
    endfor;
enddef;

vardef drawGridMinorHoriz =
    save y;
    for y = yMin step dy until yMax + dy/2:
        draw (xMin,y)--(xMax,y)
            withpen gridpenminor withcolor gridlinecolorminor;
    endfor;
enddef;

vardef drawGridDiagonals =
    save x,y,m;
    m = dy/dx;  % slope

    %-- UL to LR --
    x := xMin;
    y := yMin;
    forever:
        x := x + dx;
        y := y + dy;
        exitif (x >= xMax + (yMax-yMin)/m) and (y >= yMax + (xMax-xMin)*m);
        draw (xMin,y)--(x,yMin)
            withpen gridpendiag withcolor gridlinecolordiag;
    endfor;

    %-- LL to UR --
    x := xMin;
    y := yMax;
    forever:
        x := x + dx;
        y := y - dy;
        exitif (x >= xMax + (yMax-yMin)/m) and (y <= yMin - (xMax-xMin)*m);
        draw (xMin,y)--(x,yMax)
            withpen gridpendiag withcolor gridlinecolordiag;
    endfor;

    clip currentpicture to
        (xMin,yMin)--(xMax,yMin)--(xMax,yMax)--(xMin,yMax)--cycle;
enddef;

stop_unless_jobname_is("graphpaper");

%--- Default - 1in x 1in major & 1/4in x 1/4in minor grid cells
nextfig;
    drawGridMinorHoriz;
    drawGridMinorVert;
    drawGridMajorHoriz;
    drawGridMajorVert;
    drawBorder;
    center_fig_on_page;
endfig;

%--- 1/8in x 1/8in uniform grid squares
nextfig;
    xMin:=0in;
    yMin:=0in;
    xMax:=7.5in;
    yMax:=10in;
    dx:=1/8in;
    dy:=dx;

    drawGridMinorHoriz;
    drawGridMinorVert;
    drawBorder;

    center_fig_on_page;
endfig;

%--- 4mm x 4mm grid cells with diagonals
nextfig;
    xMin:=0mm;
    yMin:=0mm;
    xMax:=180mm;
    yMax:=240mm;
    dx:=4mm;
    dy:=dx;

    drawGridDiagonals;
    drawGridMinorHoriz;
    drawGridMinorVert;
    drawBorder;

    center_fig_on_page;
endfig;

end.
