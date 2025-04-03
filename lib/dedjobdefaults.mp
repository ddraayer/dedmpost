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
% If your file sets this before inputting the current file, the outputtemplate
% will get adjusted accordingly below. We include it here (with default value
% "eps") just as a reminder but leave it commented out so we don't actually
% override it if the user has already set it.

%outputformat := "eps";


%--- outputtemplate ---
% Set outputtemplate based on outputformat (unless it has already been changed)
if outputtemplate = "%j.%c":
    outputtemplate := "%j-%c-%{figtag}." &
        (if outputformat = "eps": "mps" else: outputformat fi);
fi
