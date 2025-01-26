%!TEX TS-program = nv-metapost
%--------------------------------------------------------------
% fleur_de_lis.mp
%   (from the original written on 2011-Jan-28)
% Copyright (c) 2025 Dean E. Draayer
%--------------------------------------------------------------
input dedjobdefaults;
input dedmpost;

color shade;
shade := .9white;

%----- FIGURES BEGIN HERE -----

nextfig;
    pair P[][], d[][];
    path p[];
    numeric u, wTot, marg, pad;

    %--- Design parameters ---
    wTot := 100mm;
    marg := 9mm;
    pad := 8mm;

    % Establish design unit u
    28u + 2marg + 2pad = sqrt(2)*wTot;

    %--- Define the control points and directions ---
    join_pts_start_at := 1;

    % Path p1 is right half of middle leaf
    P1[1] := (0u, 14u);     % Top tip of middle leaf
      d1[1] := dir(-70);
    P1[2] := (2.8u, 7u);    % Widest pt on upper middle leaf
      d1[2] := down;
    P1[3] := (0.6u, -2.6u); % Narrowest pt on middle leaf
      d1[3] := down;
    P1[4] := (2.0u, -8.5u); % Widest pt on lower middle leaf
      d1[4] := down;
    P1[5] := (0u, -14u);    % Bottom tip of middle leaf
      d1[5] := dir(-105);

    % Path p2 is outer edge of right leaf
    P2[1] := (9u, -1.7u);   % Upper tip
      d2[1] := dir(35);
    P2[2] := (5.6u, 6.4u);  % Highest pt
      d2[2] = left;
    P2[3] := (.6u, -2.6u);  % Narrowest pt
      d2[3] := down;
    P2[4] := (4.8u, -8.5u); % Lowest pt
      d2[4] := right;
    P2[5] := (6.3u, -3u);   % Lower tip
      d2[5] := dir(145);

    % Path p3 is inner edge of right leaf
    P3[1] := P2[1];         % Upper tip
      d3[1] := dir(80);
    P3[2] := (5.2u, 2u);    % Highest pt
      d3[2] = left;
    P3[3] := (2.6u, -2.3u); % Narrowest pt
      d3[3] := down;
    P3[4] := (4.6u, -5.7u); % Lowest pt
      d3[4] := right;
    P3[5] := P2[5];         % Lower tip
      d3[5] := dir(100);

    % Path p4 is axis of right leaf
    for i = 1 upto 5:
        P4[i] = .5[P2[i], P3[i]];
        d4[i] = .5[d2[i], d3[i]];
    endfor;

    % Path p5 is axis of middle leaf
    P5[1] := P1[1];
    P5[2] := P1[5];

    % Path p6 is top ring medial axis
    P6[1] := (2.9u, -.8u);
    P6[2] := (0, -1.2u);
    P6[3] := flip_horiz(P6[1]);

    % P7[1] is rightmost point of top ring
    P7[1] := P6[1] shifted (.5u*dir(10));

    % Build paths
    for i = 1 upto 6:
        p[i] := join_pts_dirs(P[i], d[i], d[i]);
    endfor;

    % p7-p9 are the rings (top to bottom)
    p7 := (p6 shifted (0,.5u))
        .. (flip_horiz P7[1]){down}
        .. (reverse p6 shifted (0,-.5u))
        .. P7[1]{up}
        .. cycle;
    p8 := (p6 shifted (0,-.5u))
        .. (flip_horiz P7[1]) shifted (0,-1.5u){down}
        .. (reverse p6 shifted (0,-2.5u))
        .. (P7[1] shifted (0, -1.5u)){up}
        .. cycle;
    p9 := p7 shifted (0, -3u);

    % p21 & p22 are the middle leaf and right leaf
    p21 := p1 -- reverse (flip_horiz p1) -- cycle;
    p22 := p2 -- reverse p3 -- cycle;

    %--- Now draw all the things ---

    % Draw frame
    fillcolor := white;
    fillstroke usquare scaled wTot rotated 45;
    fillcolor := shade;
    fillstroke usquare scaled (wTot - marg) rotated 45;
    fillcolor := white;

    % Render middle leaf
    fillstroke p21;
    draw p5;

    % Render right & left leaves
    fillstroke p22;
    draw p4;
    fillstroke flip_horiz(p22);
    draw flip_horiz(p4);

    % Render the rings
    fillstroke p7;
    fillstroke p8;
    fillstroke p9;

    currentpicture := currentpicture rotated 45;
    center_fig_on_page;
endfig;
end.
