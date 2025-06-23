%!TEX TS-program = nv-metapost
%-------------------------------------------------------------------------------
% DesignParamsSample.mp
% Copyright (c) 2026 Dean E. Draayer
%
% This design is a simple but illustrative example of a way to implement a
% design as a "design parameter set". The idea of a design here is as a set of
% numerical quantities (constants and variables) that are related to each other
% in a meaningful way (the integrity of the design) that can be readily tweaked
% to yield variations of the same design all rendered as different figures in a
% single MetaPost source file.
%
% The design here is very simple: basically a rectangle with a frame (margin).
% But it illustrates typical real cases.
%-------------------------------------------------------------------------------
input dedjobdefaults;
input dedmpost;

% For debugging/curiosity
tracingonline := 1;
tracingequations := 1;
tracingcapsules := 1;


% The design parameters
string design_params;
design_params = "etch, marg, wTot, hTot, aspratio, wIn, hIn";

% Default values for the design parameters
default.etch = 2mm;
default.marg = 6mm;
default.aspratio = 1;
default.hTot = 100mm;

vardef apply_constraints (suffix D) =
    D.wTot = D.marg + D.wIn + D.marg;
    D.hTot = D.marg + D.hIn + D.marg;
    % NB: At least one of the following must already be fixed.
    % Default values have not yet been applied.
    D.hTot = D.aspratio * D.wTot;
    supply_defaults(D);

    pair D.P[];
    path D.frameOut, D.frameIn, D.p[];
    D.frameOut = usquare xscaled D.wTot yscaled D.hTot;
    D.frameIn = usquare xscaled D.wIn yscaled D.hIn;
enddef;

vardef render_design (suffix D) =
    draw D.frameOut;
    fill D.frameIn withcolor .75white;
    draw D.frameIn;
enddef;

vardef supply_defaults (suffix D) =
    forsuffixes $ = scantokens(design_params):
        if unknown(D.$) and known(default.$):
            message("Setting " & str D.$ & " to " & str default.$);
            D.$ = default.$;
        fi;
    endfor;
enddef;


%----- FIGURES BEGIN HERE -----

nextfig;
    save D;
    apply_constraints(D);
    render_design(D);
endfig;

nextfig;
    save D;
    D.wTot = 150mm;
    apply_constraints(D);
    render_design(D);
endfig;

nextfig;
    save D;
    D.aspratio = 1.2;
    apply_constraints(D);
    render_design(D);
endfig;

end.
