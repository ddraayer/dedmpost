# Designs as Parameter Sets

## Preamble: POC

This project is a Proof Of Concept of one way to attempt to capture and
implement in MetaPost the notion of a *parametrized design". Will it work?
No promises - let's find out. Experiment, learn what works and what doesn't -
it *can't* be a *complete* failure...


## Motivation

Most of my work with MetaPost is motivated by my desire to define, manage, and
play with designs appropriate for carving patterns. These designs tend to
have geometric underpinnings, which is why I like to use MetaPost for this.

I often want to render what is essentially one **design** but with variations
in rendering, ornamentation, etc.

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
* Render multiple variations of the design, one per figure
* A set of **parameters** that play into the design
* A *design* as a "suffix parameter" (basically a MetaPost variable name) that
    gets "dotted attributes" corresponding to the design parameters. (E.g.,
    `D.margin, D.WTot`)
* A set of **constraints** that establish relations among the parameters (the integrity of the design)
* Supplying default values for parameters ("constant" versus "variable" parameters)




## Stuff ya should know

### Overall structure/approach explained

* Define `apply_constraints`: `vardef apply_constraints (suffix D) = ... enddef`. This defines how the parameters relate to each other, basically the rules that define the design.
* Define `supply_defaults` *(already done, nothing to customize, just directly copy/paste)*
* Define `render_design`: `vardef render_design (suffix D) = ... enddef`. This does all the drawing of the design based on the values of the design parameters.
* Define `beginfig/endfig` figures, one for each variation of the design. Each figure should start with a `save D;` (or whatever variable you want to use for your design; otherwise constraint application among D.<PARAMN> values seep out into global context and thus carry over into subsequent figures (if using the same variable name) - largely defeating the purpose of the whole endeavor.


### Defining the Set of Parameters

Design parameter names are defined as a comma-separated list of names assigned to a string variable called `design_params`:

```
% The design parameters
string design_params;
design_params = "<comma-separated param names>";
```

The order *does* matter: the order the parameter names are listed is the order in which, during constraint application, the free parameter values get filled with default values (for those parameters for which a default is defined). Every assignment of a default further "rigidizes" the design - until at some point all th params become determined (or contradict each other).


### Defaults

#### How default parameter values are defined

```
defaults.<p1> = <v1>;
defaults.<p2> = <v2>;
...
```

#### How default parameter values get used

This is performed by `supply_defaults` - a helper function that (under the conventions of this entire approach to design parameter sets) doesn't change (it's copy-pasted for each design instance/file).


## Example

Here's a very minimal example illustrating how to implement a design in the manner presented. See `DesignParamsSample.mp` for a more fleshed out example. See `DesignParamSet-TEMPLATE.mp` for a template that puts the scaffolding in place, leaving placeholders that need to be filled in to define an actual design.

```
% W - total width of horizontal segment
% L - length of left segment
% M - length of middle segment
% R - length of right segment
% g - width of gap between segments
string design_params;
design_params = "g, W, L, M, R";

% Default values for the design parameters
default.L = 1cm;
default.M = 5cm;
default.R = 2cm;
default.g = 2mm;

vardef apply_constraints (suffix D) =
    % Constraint: the whole is the sum of its parts
    D.W = D.L + D.g + D.M + D.g + D.R;
    % Set undetermined parts to their default values
    supply_defaults(D);
enddef;

vardef supply_defaults (suffix D) =
    forsuffixes $ = scantokens(design_params):
        if unknown(D.$) and known(default.$):
            message("Setting " & str D.$ & " to " & str default.$);
            D.$ = default.$;
        fi;
    endfor;
enddef;

vardef render_design (suffix D) =
    draw_segments(D.L, D.M, D.R, D.g);
enddef;

vardef draw_segments(expr l,m,r,g) =
% Draw line segment made of segments of lengths l, m, r with gap g between them
% |<-  l  ->|<- g ->|<-   m   ->|<- g ->|<-  r  ->|
    interim linecap := butt;
    pickup pencircle scaled 4mm;
    draw (0,0) -- (l,0) withcolor red;
    draw (l,0) -- (l+g,0) withcolor black;
    draw (l+g,0) -- (l+g+m,0) withcolor .5white;
    draw (l+g+m,0) -- (l+g+m+g,0) withcolor black;
    draw (l+g+m+g,0) -- (l+g+m+g+r,0) withcolor green;
enddef;

beginfig(1);
    save D;
    D.W = 12cm;
    2D.L = D.R;
    apply_constraints(D);
    render_design(D);
endfig;

beginfig(2);
    save D;
    D.M = 3D.L;
    D.L = D.R = 1cm;
    D.W = 10cm;
    apply_constraints(D);
    render_design(D);
endfig;

end.
```
