%!TEX TS-program = nv-metapost
%-------------------------------------------------------------------------------
% DesignParamsSet-Template.mp
% Copyright (c) 2026 Dean E. Draayer
%
% Template file framing out the skeleton for designs with variations defined
% by sets of parameters.
%-------------------------------------------------------------------------------



% OPTIONAL: For debugging/curiosity - nice for seeing how and when param values get "fixed"
tracingonline := 1;
tracingequations := 1;
tracingcapsules := 1;



% Design parameters
string design_params;
design_params = "<COMMA_SEPARATED_LIST_OF_PARAMETER_NAMES>";

% Default values for the design parameters
default.<PARAM1> = <VALUE1>;
default.<PARAM2> = <VALUE2>;
default.<PARAM3> = <VALUE3>;
...


%----- apply_constraints(D) -----
%
%
% NB: This should end with a call to supply_defaults(D) - it fills in any
% remaining undetermined params with default values.
vardef apply_constraints (suffix D) =
    % Defined onstraints between the design params here.
    % E.g., D.<PARAM1> = D.<PARAM2> + ... + <D.PARAMN>;
    <TBD>;
    % Set undetermined parts to their default values
    supply_defaults(D);
enddef;


%----- render_design(D) -----
% Render the design, i.e. draw it, based on the values of the design parameters.
% This is totally up to you.
vardef render_design (suffix D) =
    <TBD>;
enddef;


%----- supply_defaults(D) -----
% Loop through the design parameters, one by one.
% For each design param <param>, if D.<param> is not yet known but
% defaults.<param> is, set D.<param> = default.<param>.
%
% Helper function - boilerplate (nothing to customize here). It should get
% called by `apply_constraints` as its last statement before returning.
vardef supply_defaults (suffix D) =
    forsuffixes $ = scantokens(design_params):
        if unknown(D.$) and known(default.$):
            message("Setting " & str D.$ & " to " & str default.$);
            D.$ = default.$;
        fi;
    endfor;
enddef;



%----- FIGURES BEGIN HERE -----

beginfig(1);
    save D;
    % Customize parameter values/relations
    % E.g. something like:
    % D.PARAM1 = 1cm;
    % D.PARAM2 + D.PARAM3 = 5D.PARAM1;
    % ...
    <TBD>;
    % Fixate the design params & render the design
    apply_constraints(D);
    render_design(D);
endfig;

beginfig(2);
    save D;
    % Customize parameter values/relations
    % E.g. something like:
    % D.PARAM1 = 1cm;
    % D.PARAM2 + D.PARAM3 = 5D.PARAM1;
    % ...
    <TBD>;
    % Fixate the design params & render the design
    apply_constraints(D);
    render_design(D);
endfig;

end.
