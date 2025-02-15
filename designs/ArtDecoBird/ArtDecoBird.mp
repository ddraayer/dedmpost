%!TEX TS-program = nv-metapost
%--------------------------------------------------------------
% ArtDecoBird.mp (from 2011-Dec-23)
% Copyright (c) 2025 Dean E. Draayer
%--------------------------------------------------------------
input dedjobdefaults;
input dedmpost;

%--- Convenient directions ---
pair N, W, S, E, NE, NW, SW, SE;
N = up; W = left; S = down; E = right;
NE = ( 1, 1);
NW = (-1, 1);
SW = (-1,-1);
SE = ( 1,-1);


nextfig;
    transform mirror;
    pair PBeak, PElbow, PHead[], PBody[], PTail[],
        PWingArc[], PWingTip, PWingBackEnd,
        PBackStepPt[], PBackStepStart[], DBackStepStart[];
    path pAxis, pHead, pBeak, pBody, pTail,
        pWingArc[], pWingFront, pWingEnd, pWingLine[], pBackStep[];
    numeric u, wTot, marg, pad, wBirdSqr;
    numeric angBeak, wingArcRatio, wingWidth, tBackStepStart[];

    mirror = identity reflectedabout(SW,NE);

    % Establish design parameters & relations
    wTot = 100mm;
    marg = 5mm;
    pad = 4mm;

    20u = wBirdSqr;
    wTot = wBirdSqr + 2pad + 2marg;

    % Establish construction points
    pAxis = (0,0)--(wBirdSqr*NE);

    PHead1 = 2.5u*NE;
    PHead3 = PHead1 shifted (2.8u*NE);
    PHead2 = .5[PHead1,PHead3] shifted (1.1u*NW);
    pHead = PHead1{NW} .. PHead2{NE} .. PHead3{SE};

    angBeak = 15;
    PBeak = PHead1 shifted (1u*SW);
    pBeak = (PBeak -- (PBeak shifted (4u*dir(45 + angBeak)))) cutafter pHead;

    PBody1 = PHead3 shifted (.9u*SW);
    PBody2 = 8.5u*NE shifted (1.9u*NW);
    PBody3 = 15u*NE shifted (0.9u*NW);
    PBody4 = 20u*NE shifted (2.7u*W);
    pBody = (PBody1{NW} .. PBody2{NE} .. PBody3{NE} .. PBody4)
                cutbefore pHead;

    PTail1 = PBody4;
    PTail2 = 17u*NE;
    pTail = PTail1 .. {SW}PTail2;

    PElbow = 6u*N;

    wingArcRatio = .83;
    PWingArc1 = (PElbow{N} .. {W}(PElbow transformed mirror))
                intersectionpoint pAxis;
    for i = 1 upto 4:
        PWingArc[i] = PWingArc[i-1] scaled wingArcRatio;
        pWingArc[i] = (PElbow .. {SE}PWingArc[i]) cutafter pBody;
    endfor;

    PWingTip = 20u*N;
    PWingBackEnd = PWingTip shifted (6.5u*E) shifted (4.5u*S);
    wingWidth = xpart PWingBackEnd - xpart PWingTip;
    pWingFront = PElbow -- PWingTip;
    pWingEnd = PWingTip{E} .. PWingBackEnd{S};

    for i = 1 upto 5:
        pWingLine[i] = (pWingFront shifted ((1 + 2i)/11*wingWidth*E))
            cutbefore pWingArc1 cutafter pWingEnd;
        draw pWingLine[i];
    endfor;

    for i = 1 upto 6:
        tBackStepStart[i] =
            if odd(i):
                xpart (pBody intersectiontimes
                    (((0,0)--(-20u,20u)) shifted ((8.9+2(i div 2))*u*NE)))
            else:
                tBackStepStart[i-1]
            fi;
        PBackStepStart[i] = point tBackStepStart[i] of pBody;
        DBackStepStart[i] = direction tBackStepStart[i] of pBody;
        PBackStepPt[i] = (11 + .9i + .1(i mod 2))*u*NE;
        pBackStep[i] = PBackStepStart[i]{DBackStepStart[i]} .. PBackStepPt[i];
        draw pBackStep[i];
    endfor;

    % Draw bird
    draw pHead;
    draw pBeak;
    draw pBody;
    draw pTail;
    for i = 1 upto 4:
        draw pWingArc[i];
    endfor;
    draw pWingFront;
    draw pWingEnd;
    draw currentpicture transformed mirror;

    % Draw design points - comment this out if you don't want them
    numeric i;
    pair P,Ps[];
    forsuffixes P=PBeak,PElbow,PWingTip, PWingBackEnd:
        draw P withpen pensquare scaled 2bp withcolor red;
    endfor;
    forsuffixes Ps=PHead,PBody,PTail,PWingArc,
            PBackStepPt,PBackStepStart,DBackStepStart:
        i:=1;
        forever:
            exitif unknown(Ps[i]);
            draw Ps[i] withpen pensquare scaled 2bp withcolor red;
            i:=i+1;
        endfor;
    endfor;

    % Shift origin to frame lower left, then draw frame
    currentpicture := currentpicture shifted ((marg + pad)*(1,1));
    draw unitsquare scaled wTot withpen pencircle;
    draw unitsquare scaled (wTot - 2marg) shifted (marg,marg);
endfig;
end.
