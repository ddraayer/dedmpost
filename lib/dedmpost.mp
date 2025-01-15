%------------------------------------------------------------------------------
% dedmpost.mp
%   DED's basic MetaPost format
% Copyright (c) 2025 Dean E. Draayer
%------------------------------------------------------------------------------

%----- PREAMBLE STUFF -----

% Quick out if file has already been input
if known _dedmpost_version: endinput fi;
string _dedmpost_version;
_dedmpost_version = "0.8";
message "Loading dedmpost.mp v" & _dedmpost_version;


%--- stop_if_imported ---
% If the basename of the file currently being input is not the same as the
% jobname, then stop inputting this file at this point.
% XXX -This is just an aspiration. I'm not aware of any way to determine the
% current input file's basename. I'm keeping this here in the hope that some day
% this will be possible. In the meantime there's stop_unless_jobname_is(s).
%def stop_if_imported =
%   if jobname <> CURRENT_INPUT_FILE_BASENAME: endinput fi;
%enddef;

%--- stop_unless_jobname_is(s) ---
% If the jobname (by default the basename of the top-level file being processed)
% is not s, then stop inputting the file right now. This allows a .mp file
% that is meant to be input (a "library" file) to do extra things (such as
% generate its own figures) when processed directly but behave properly when
% input by another file.
def stop_unless_jobname_is (expr s) =
   if jobname <> s: endinput fi;
enddef;


%----- AUTOMATIC FIGURE NUMBERING -----
% Use `nextfig` instead of `beginfig(n)` to automatically get figures numbered
% consecutively starting from 1.

fignum := 0;

def nextfig =
    fignum := fignum + 1;
    beginfig(fignum);
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


%----- NOTION OF PAGE/CANVAS -----
% Use pgwd and pght to set the size of your design canvas. Often these are set
% to the size of the desired printed page (typically when printing figures that
% fit entirely on a single printed page). But they can be ajdusted to suit the
% "canvas" that is most appropriate for your project (they are intended for
% design purposes only and do not have any special connection to printer pages).

pgwd := 8.5in;
pght := 11in;

% Shift currentpicture so that its origin lies at the center of the page
def shift_fig_to_page_center =
    currentpicture := currentpicture shifted (pgwd/2,pght/2);
enddef;

% Shift currentpicture so that its bounding box center lies at the page center.
def center_fig_on_page =
    currentpicture := origin_at_center(currentpicture) shifted (pgwd/2,pght/2);
enddef;


%----- FILL & STROKE MACROS -----
% One very common drawing operation is to fill a closed path with one color
% and at the same time stroke the path with a different color. In plain
% MetaPost this must be done in two steps.
%
% Another situation is drawing a path and its "spine" or a "hollowed out" path.
% Basically this involves drawing the path twice: first wider with the outer
% "stroke" color, and then again with narrower "fill" color.

% Variables for fill/stroke macros
color fillcolor, strokecolor;
pen strokepen;
numeric strokewidth;

fillcolor := white;
strokecolor := black;
strokepen := pencircle;
strokewidth := 1pt;

%--- fillstroke(p) ---
% Fills path p with fillcolor and strokes it with strokecolor using
% strokepen of width strokewidth.
vardef fillstroke (expr p) =
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

%--- flip_horiz(p) ---
% Return p reflected about the vertical axis
def flip_horiz (expr p) =
    p reflectedabout (up, down)
enddef;

%--- flip_vert(p) ---
% Return p reflected about the horizontal axis
def flip_vert (expr p) =
    p reflectedabout (left, right)
enddef;


%----- PATH BUILDING -----

%--- join_pts_dirs (Pt, Din, Dout) ---
% Return a path constructed from the sequence of points Pt[i] for i=0,1,...n-1
% with in-directions Din[i] and out-directions Dout[i]. Here n is the number of
% points (n is the smallest nonnegative integer such that P[n] is undefined).
% Directions may be defined or omitted at will. (
vardef join_pts_dirs (suffix Pt, Din, Dout) =
    save n, i;

    % Determine Pt index range (0,1,...,n-1)
    n := 0;
    forever:
        exitif unknown(Pt[n]);
        n := n + 1;
    endfor;

   Pt[0]
   if known(Dout[0]): {Dout[0]} fi
   for i = 1 upto n-1:
       ..
       if known(Din[i]): {Din[i]} fi
       Pt[i]
       if known(Dout[i]): {Dout[i]} fi
   endfor
enddef;

%--- cycle_pts_dirs (Pt, Din, Dout) ---
% Same as join_pts_dirs except it returns a cycle (honoring the in-direction
% at the first point if defined).
vardef cycle_pts_dirs (suffix Pt, Din, Dout) =
    join_pts_dirs(Pt, Din, Dout)
    ..
    if known(Din[0]): {Din[0]} fi
    cycle
enddef;

stop_unless_jobname_is("dedmpost");


%----- ADD SOME SAMPLE FIGURES HERE -----

end.
