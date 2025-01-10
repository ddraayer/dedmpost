%------------------------------------------------------------------------------
% dedjobdefaults.mp
%   DED's preferred MetaPost job-related defaults
% Copyright (c) 2025 Dean E. Draayer
%
% These settings are factored out to a separate file because they have effects
% on runtime behavior that the user might want to change and thus should not get
% overridden by the mere act of importing a more typical library file that just
% extends functionality.
%------------------------------------------------------------------------------

%--- prologues ---
prologues := 3;


%--- outputformat ---
% Supported values for outputformat: "eps" (default), "png", "svg"
% If your file set this before inputting this file, the outputtemplate will get
% adjusted accordingly below (that's why we leave it commented out here).

%outputformat := "eps";


%--- outputtemplate ---
% Set outputtemplate based on outputformat (unless it has already been changed)
if outputtemplate = "%j.%c":
    outputtemplate := "%j-%c." & (if outputformat = "eps": "mps" else: outputformat fi);
fi
