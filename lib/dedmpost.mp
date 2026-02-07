%------------------------------------------------------------------------------
% dedmpost.mp
%   DED's basic MetaPost format
% Copyright (c) 2026 Dean E. Draayer
%------------------------------------------------------------------------------

%----- PREAMBLE STUFF -----

% Quick out if file has already been input
if known _dedmpost_version: endinput fi;
string _dedmpost_version;
_dedmpost_version = "0.81";
message "Loading dedmpost.mp v" & _dedmpost_version;


%--- stop_if_imported ---
% If the basename of the file currently being input is not the same as the
% jobname, then stop inputting this file at this point.
% XXX -This is just an aspiration. I'm not aware of any way to determine the
% current input file's basename. I'm keeping this here in the hope that some day
% someone will tell me how to fill in CURRENT_INPUT_FILE_BASENAME. In the
% meantime one can get by with stop_unless_jobname_is.
%def stop_if_imported =
%   if jobname <> CURRENT_INPUT_FILE_BASENAME: endinput fi;
%enddef;

%--- stop_unless_jobname_is(s) ---
% If the jobname is not s, then stop inputting the file right now.
% (By default jobname is the basename of the top-level file being processed.)
% This allows a .mp file that is intended as a "macro package" to do extra
% things (such as generate its own figures) when processed directly yet behave
% properly when input by another file.
def stop_unless_jobname_is (expr s) =
   if jobname <> s: endinput fi;
enddef;


%----- FIGURE NUMBERING/TAGGING -----
% Use `nextfig` instead of `beginfig(n)` to automatically get figures numbered
% consecutively starting from 1. Escape sequence %c (or %{charcode}) in the
% outputtemplate will be replaced by the value of `fignum`.
newinternal numeric fignum;
fignum := 0;

def nextfig =
    fignum := fignum + 1;
    beginfig(fignum);
enddef;

% Use `taggedfig(tag)` to supply a string `tag` to incorporate into the output
% filename wherever `%{figtag}` appears in `outputtemplate`.
% NB: taggedfig calls nextfig, so fignum gets incremented at each call.
% NB: The outputtemplate mechanism requires figtag to be declared as internal.
newinternal string figtag;
figtag := "Fig";

vardef taggedfig (expr tag) =
    interim figtag := tag;
    nextfig;
enddef;


%----- ORIGIN SHIFTING -----
% Shift a picture/path/pen (anything with a bounding box) so that the origin is
% located at one of the bounding box's points of interest (center or any of its
% four corners).

def origin_at_center (expr p) =
    p shifted -(center p)
enddef;

def origin_at_UL (expr p) =
    p shifted -(ulcorner p)
enddef;

def origin_at_LL (expr p) =
    p shifted -(llcorner p)
enddef;

def origin_at_UR (expr p) =
    p shifted -(urcorner p)
enddef;

def origin_at_LR (expr p) =
    p shifted -(lrcorner p)
enddef;


%----- NOTION OF PAGE/CANVAS -----
% Use page_width and page_height to set the size of your design canvas. Often
% these are set to the size of the desired printed page (typically when printing
% figures that fit entirely on a single printed page). But they can be ajdusted
% to suit the "canvas" that is most appropriate for your project (they are
% intended for design purposes only and do not have any special connection to
% printer pages).

page_width := 8.5in;
page_height := 11in;

% Shift currentpicture so that its origin lies at the center of the page
def shift_fig_to_page_center =
    currentpicture := currentpicture shifted (page_width/2,page_height/2);
enddef;

% Shift currentpicture so that its bounding box center lies at the page center
def center_fig_on_page =
    currentpicture :=
        origin_at_center(currentpicture) shifted (page_width/2,page_height/2);
enddef;


%----- CONVENIENT PATHS -----
% Paths `u<shape>` are "unit" paths of the indicated shape; i.e., they have
% bounding box with dimensions 1x1 with origin at the bounding box center.

path usquare, ucircle, udiamond;
usquare = origin_at_center(unitsquare);
ucircle = fullcircle;
udiamond = (right--up--left--down--cycle) scaled 1/2;


%----- DIRECTION-RELATED MACROS -----

%--- dir_in t of p ---
% Return a vector pointing in the direction of entry at point t of p.
vardef dir_in expr t of p =
    point t of p - precontrol t of p
enddef;

%--- dir_out t of p ---
% Return a vector pointing in the direction of exit at point t of p.
vardef dir_out expr t of p =
    postcontrol t of p - point t of p
enddef;


%----- ARCPOINT MACROS -----

%--- arcpoint L of P ---
% Return the point on path P that lies length L (in the sense
% of arclength) along P from its starting point
def arcpoint expr L of P =
    point (arctime L of P) of P
enddef;

%--- relarcpoint r of P ---
% Return the point on path P that lies the fraction r of the total
% length P from its starting point
def relarcpoint expr r of P =
    point (arctime (r*(arclength P)) of P) of P
enddef;

%--- polysegmented (p,n) ---
% Return the polygonal path/cycle obtained by connecting the points on
% path/cycle p that divide p into n equal-arclength segments.
% Note: This provides a convenient way to access a sequence of equally spaced
% points along a path. They are accessible at the integer parameter values of
% the polysegment path q, i.e., `point t of q` for t=0,1,...,length(q).
vardef polysegmented (expr p, n) =
    save i,s;
    numeric i,s;

    % s is the length of each segment
    n*s = arclength p;

    for i = 0 upto n-1:
        arcpoint i*s of p --
    endfor
    if cycle(p): cycle else: point infinity of p fi
enddef;


%----- FILL & STROKE MACROS -----

%--- drawfilled(c) p ---
% Fill contour p with color c, then stroke p with currentpen.
vardef drawfilled(expr c) expr p =
    fill p withcolor c;
    draw p;
enddef;

%--- drawhollowed(wd_out,wd_in,fillcolor) p ---
% Draw path p twice, first with pencircle scaled wd_out, then with pencircle
% scaled wd_in using color fillcolor.
vardef drawhollowed(expr wd_out, wd_in, fillcolor) expr p =
    draw p withpen pencircle scaled wd_out;
    draw p withpen pencircle scaled wd_in withcolor fillcolor;
enddef;


% One very common drawing operation is to fill a closed path with one color and
% at the same time stroke the path with a different color. In plain MetaPost
% this must be done in two steps. The fillstroke macro conveniently takes care
% of doing both of these in one call.
%
% Another situation is drawing a path and its "spine" or a "hollowed out" path.
% Basically this involves drawing the path twice: first wider with the outer
% "stroke" color, and then again with narrower "fill" color. That's what
% hollowstroke does.

% "Public" variables for fill/stroke macros
color fillcolor, strokecolor;
pen strokepen;
numeric strokewidth;

fillcolor := white;
strokecolor := black;
strokepen := pencircle;
strokewidth := 1pt;

%--- fillstroke p ---
% Fills path p with fillcolor and strokes it with strokecolor using
% strokepen of width strokewidth.
vardef fillstroke expr p =
    fill p withcolor fillcolor;
    draw p withpen strokepen scaled strokewidth withcolor strokecolor;
enddef;

%--- hollowstroke(p,wd_out,wd_in) ---
% Draw path p twice, first with strokecolor using strokepen scaled wd_out,
% then with fillcolor using strokepen scaled wd_in.
vardef hollowstroke (expr p, wd_out, wd_in) =
    draw p withpen strokepen scaled wd_out withcolor strokecolor;
    draw p withpen strokepen scaled wd_in withcolor fillcolor;
enddef;


%--- COMMON TRANSFORMATIONS ---

%--- flip_horiz p ---
% Return p reflected about the vertical axis
def flip_horiz expr p =
    p reflectedabout (up, down)
enddef;

%--- flip_vert p ---
% Return p reflected about the horizontal axis
def flip_vert expr p =
    p reflectedabout (left, right)
enddef;


%----- PATH BUILDING -----
newinternal numeric join_pts_start_at;
join_pts_start_at := 0;

%--- join_pts_dirs (Pt, Din, Dout) ---
% Return a path constructed from the sequence of points Pt[i] for
% i=s,s+1,...,e with in-direction Din[i] and out-direction Dout[i] at Pt[i].
% Here s=join_pts_start_at and e is the smallest integer (>=s-1) such that
% P[e+1] is undefined. Directions need not be defined at every (or even any)
% point.
vardef join_pts_dirs (suffix Pt, Din, Dout) =
    save s, e, i;

    % Determine Pt index range (s,s+1,...,e)
    s := join_pts_start_at;
    e := s;
    forever:
        exitif unknown(Pt[e]);
        e := e + 1;
    endfor;
    e := e - 1;

    % Special treatment for 1st pt since paths can't start with an in-direction
    if known(Pt[s]):
        Pt[s]
        if known(Dout[s]): {Dout[s]} fi
    fi
    for i = s+1 upto e:
       ..
       if known(Din[i]): {Din[i]} fi
       Pt[i]
       if known(Dout[i]): {Dout[i]} fi
    endfor
enddef;

%--- cycle_pts_dirs (Pt, Din, Dout) ---
% Same as join_pts_dirs except it returns a cycle, honoring the in-direction
% at the first point if defined.
vardef cycle_pts_dirs (suffix Pt, Din, Dout) =
    join_pts_dirs(Pt, Din, Dout)
    ..
    if known(Din[join_pts_start_at]): {Din[join_pts_start_at]} fi
    cycle
enddef;


%----- SHAPES -----

%--- rounded_rect(w,h,r) ---
% Parameters:
%   w - width of rectangle
%   h - height of rectangle
%   r - radius of corners
% Returns a rounded rectangle of the indicated dimensions as a cycle.
vardef rounded_rect (expr w,h,r) =
    save W,H,K;
    path W,H,K;
    K = quartercircle scaled 2r;
    H = (w/2, -(h/2-r))--(w/2, h/2-r);
    W = (w/2-r, h/2)--(-(w/2-r), h/2);
    buildcycle (
        H,
        K shifted (w/2-r,h/2-r),
        W,
        K rotated 90 shifted (-(w/2-r),h/2-r),
        H rotated 180,
        K rotated 180 shifted (-(w/2-r),-(h/2-r)),
        W rotated 180,
        K rotated 270 shifted (w/2-r,-(h/2-r))
    )
enddef;


%----- TILE REPLICATION -----

%--- tiling_MxN (tile, M, N) ---
% Return a picture obtained by drawing an M-rows-by-N-columns rectangular array
% of copies of tile (the original tile appears at the lower left).
vardef tiling_MxN(expr tile, M, N) =
    save w,h;
    numeric w,h;
    (w, h) = urcorner tile - llcorner tile;
    image(
        for i = 0 upto N-1:
            for j = 0 upto M-1:
                draw tile shifted (i*w, j*h);
            endfor;
        endfor;
    )
enddef;

%--- transformed_replicas (tile, n, tr) ---
% Parameters:
%   tile - a picture
%   n    - a numeric
%   tr   - a transformation
% Return a picture consisting of n copies of tile, applying tr to the latest
% replica to generate the next one.
vardef transformed_replicas (expr tile, n, tr) =
    save i, pic;
    numeric i;
    picture pic;
    image (
        pic := tile;
        for i = 1 upto n:
            draw pic;
            pic := pic transformed tr;
        endfor;
    )
enddef;

%--- shifted_replicas (tile, reps, displ) ---
% Return a picture consisting of reps copies of tile,
% with displ as the displacement between successive tiles.
vardef shifted_replicas (expr tile, reps, displ) =
    transformed_replicas(tile, reps, identity shifted displ)
enddef;

stop_unless_jobname_is("dedmpost");



%----- SAMPLE FIGURES HERE -----

input dedjobdefaults;

% A simple polysegmented path
taggedfig("PolysegmentedPath");
    numeric i;
    path p,q;
    p = ((-1,0){left}..(-1,2){right}..(0,0)..
         {right}(1,-1)..{up}(2,0)..(1,0)) scaled 1cm;
    q = polysegmented(p, 12);
    draw p withpen pencircle scaled 1pt;
    draw q withpen pencircle scaled .7pt withcolor red;
    for i = 0 upto length q:
        draw point i of q withpen pencircle scaled 2.5pt withcolor red;
    endfor;
endfig;

% Using polysegmented to draw an oval with "spokes" emanating from a point
taggedfig("OvalWithSpokes");
    numeric i,N;
    pair C;
    path p,q;

    N = 16;
    C = (-1cm, -.5cm);
    p = ucircle xscaled 6cm yscaled 3cm;
    q = polysegmented(p, N);
    draw p withpen pencircle scaled 1pt;
    pickup pencircle scaled .5pt;

    % Dashed spokes interpolating along the path's "time" parameter interval
    for i = 0 upto N-1:
        draw C -- (point i*(length(p)/N) of p) withcolor .8white dashed evenly;
    endfor;

    % Solid spokes using the evenly spaced vertices of the polysegment
    for i = 0 upto (length q) - 1:
        draw C -- point i of q;
    endfor;
endfig;

taggedfig("DirectionsInOut");
    pair P;
    path p;
    numeric u;
    u := 1cm;
    p := (0,0){up} .. (3,3) .. (4,2) .. {dir (45+180)}(3,1){right} .. {down}(4,0) -- (2,0){dir -45} .. cycle;
    p := p xscaled u yscaled u;
    draw p;
    pickup pencircle scaled .5bp;
    for t = 0 step .5 until length(p):
        P := point t of p;
        drawarrow (P - dir_in t of p) -- P withcolor red;
        drawarrow P -- (P + dir_out t of p) withcolor green;
        drawdot P withpen pencircle scaled (if floor(t) = t: 3bp else: 2bp fi);
    endfor;
endfig;

% TODO: join_pts_dirs & hollowstroke example

% TODO: cycle_pts_dirs & fillstroke example

% A simple MxN tiling example
taggedfig("Tiling2D");
    picture tile;
    tile = image(filldraw udiamond xscaled .8cm yscaled 1cm withcolor .5white);
    draw tiling_MxN(tile, 3, 7);
endfig;

% Replicate tiles along one direction
taggedfig("ShiftedReplicas");
    picture tile;
    tile = image(draw udiamond xscaled 1.5cm yscaled 2cm);
    draw shifted_replicas(tile, 10, (.8cm,.2cm));
endfig;

% Example of transformed_replicas
taggedfig("TransformedReplicas");
    picture tile;
    transform tr;

    tile = image(
        fillstroke udiamond xscaled 1cm yscaled 1cm shifted (2cm*right);
    );
    tr = identity xscaled .95 yscaled .95 rotated 10;
    draw transformed_replicas(tile, 35, tr);
endfig;

end.
