# POC: Designs as Parameter Sets

>This project is a Proof Of Concept of one way to attempt to capture and
implement in MetaPost the notion of a *parametrized design*. Will it work?
No promises - let's find out. Experiment, learn what works and what doesn't -
it *can't* be a *complete* failure...something will be learned.


## Motivation

Most of my work with MetaPost is motivated by my desire to define, manage, and
play with designs appropriate for carving patterns. These designs tend to
have geometric underpinnings and are , which is why I like to use MetaPost for this.

I often want to render what is conceptually one **design** but with the ability to experiment with variations in rendering, ornamentation, etc.

MetaPost is wonderful in it's abilities, but it is weird in its expression
(highly unconventional compared to other programming languages). The approach
outlined here is intended to help the user reduce confrontations with the
weirdness. It does so in a relatively idiomatic MetaPost way.

There *is* a straightforward and obvious way to define parameterized designs in
MetaPost: define `vardef` macros that take the design parameters as arguments,
establish constraints among them, and perform the requisite rendering.
Although conceptually simple, it's quite cumbersome in practice. The main drawback
is that there can be a large number of parameters constituting a design. That's
a lot of arguments to pass to a macro. And in practice a good number of parameters
are effectively constant from a design standpoint (e.g., thickness of a trough or
various margins widths). It greatly eases the burden for the user if defaults for
these can be defined and relied upon. This frees variations of a design to focus
on the *interesting* parameters, those that *really* make a difference.


## Overview

* One **design** per MetaPost script
* A set of **parameters** that play into the design
* A set of **constraints** that establish relations among the parameters (the "integrity" of the design)
* Optional **default values** for parameters
* Rendering **multiple variations** of the design
* A *design* as a "suffix parameter" (basically a MetaPost variable name) that gets "dotted attributes" corresponding to the design parameters (e.g., `D.margin`, `D.WTot`)


## How It Goes

### Define the Set of Parameters

The design parameter names are defined as a comma-separated list of names assigned to a string variable called `design_params`:

```
% The design parameters
string design_params;
design_params = "<comma-separated param names>";
```

The order in which the parameter names are listed is the order in which, during constraint application, the free parameter values get filled with default values (for those not-yet-determined parameters for which a default is defined).


### Define the Defaults

#### How default parameter values are defined

```
% The default parameter values
defaults.<p1> = <v1>;
defaults.<p2> = <v2>;
...
```

#### How default parameter values get used

This is performed by the `supply_defaults` macro - a boiler-plate helper function. The `apply_constraints` macro should call this macro after setting up the constraints.


### Define the Macros

* `supply_defaults` *(already done, nothing to customize, just directly copy/paste the macro definition)*. This is typically called from `apply_constraints`.
* `apply_constraints`: `vardef apply_constraints (suffix D) = ...; supply_defaults(D); enddef`. This defines how the parameters relate to each other, basically the rules and relationships that define the design. Typically this establishes the constraints and finishes with a call to `supply_defaults` to fill in any remaining unfixed parameters.
* `render_design`: `vardef render_design (suffix D) = ... enddef`. This does all the drawing of the design based on the values of the design parameters.

NB: One reason we keep `apply_constraints` and `render_design` separate is to support closely-related designs (i.e., those that can use the same rendering code) with slight variations in the constraints.


### Render the Design Variants

Each variation of the design occurs as a figure:

```
beginfig(N);
    save D;
    % Set the specific parameter values/relations for this variant
    D.<param1> = ...;
    D.<param2> = ...;
    ...
    apply_constraints(D);
    render_design(D);
endfig;
```

Each figure should start with a `save D;` (or whatever variable you want to use for your design). This ensures that each figure gets its own fresh local variable and avoids leaking constraints out into global context and thus carry over into subsequent figures (if using the same variable name) - largely defeating the purpose of the whole endeavor.


## Example

Here's a simple example illustrating how to implement a design in the manner presented. See `DesignParamsSample.mp` for a more fleshed out example.

```
% Design: 3 line segments drawn end to end with a gap between them

%--- Parameters
%   W - total width of the design (horizontal segments plus gaps)
%   L - length of left segment
%   M - length of middle segment
%   R - length of right segment
%   g - width of gap between segments
string design_params;
design_params = "g, W, L, M, R";

%--- Default values
default.L = 1cm;
default.M = 5cm;
default.R = 2cm;
default.g = 2mm;

%--- Macros
vardef supply_defaults (suffix D) =
    forsuffixes $ = scantokens(design_params):
        if unknown(D.$) and known(default.$):
            message("Setting " & str D.$ & " to " & str default.$);
            D.$ = default.$;
        fi;
    endfor;
    % Report any parameters that are still undetermined
    forsuffixes $ = scantokens(design_params):
        if unknown(D.$):
            message("Parameter " & str D.$ & " is still unknown");
        fi;
    endfor;
enddef;

vardef apply_constraints (suffix D) =
    % Constraint: the whole is the sum of its parts
    D.W = D.L + D.g + D.M + D.g + D.R;
    % Set undetermined parts to their default values
    supply_defaults(D);
enddef;

vardef render_design (suffix D) =
    draw_segments(D.L, D.M, D.R, D.g);
enddef;

vardef draw_segments(expr l,m,r,g) =
% Draw line segment made of segments of lengths l, m, r with gap g between them
% |<-  l  ->|<- g ->|<-   m   ->|<- g ->|<-  r  ->|
    interim linecap := butt;
    pickup pencircle scaled 4mm;
    draw (0,0) -- (l,0) withcolor (1, .25, .25);
    draw (l,0) -- (l+g,0) withcolor .75white;
    draw (l+g,0) -- (l+g+m,0) withcolor (.5, .5, 1);
    draw (l+g+m,0) -- (l+g+m+g,0) withcolor .75white;
    draw (l+g+m+g,0) -- (l+g+m+g+r,0) withcolor (.9, .9, 0);
enddef;

%--- Drawing the variants

beginfig(1);
    % Fix the overall width
    % Make the right segment twice the length of the left segment
    % Use defaults for gaps and middle segment length
    save D;
    D.W = 12cm;
    D.R = 2D.L;
    apply_constraints(D);
    render_design(D);
endfig;

beginfig(2);
    % Make middle segment length the sum of the lengths of left segments
    % Set left & right segments to 1cm
    % Set the overall width to 10cm
    % Constraint application will establish the length of the gaps
    save D;
    D.M = 2(D.L + D.R);
    D.L = D.R = 1cm;
    D.W = 10cm;
    apply_constraints(D);
    render_design(D);
endfig;
end.
```
