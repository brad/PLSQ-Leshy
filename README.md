PLSQ Leshy
==========
This is a fully scripted/parametric version of the [PL2Q Hugin quadcopter](http://www.thingiverse.com/thing:19161). I wanted to make changes, and I'm most comfortable in OpenSCAD, so I ported it.

To keep with the mythological creature naming scheme, and because he's a shape shifter I called him [Leshy](https://en.wikipedia.org/wiki/Leshy). ;)

I haven't printed everything yet, but all the STLs slice fine with Slic3r (initially some STLs had problems slicing because of stupid self-intersecting facets!).

For this first version, I did my best to replicate the PL2Q Hugin as closely as possible (everything is +-0.1mm) and I only added a couple things.

First, I wasn't getting a strong arm with the splitting approach used for the PL2Q Hugin, so I created a coupler to connect each half. That way the joint is the strongest part of the design rather than the weakest, without much extra weight.

The only other modification I made was to stamp the name "Leshy" on the canopy using the ArchitectsDaughter font from the [More Fontz!](http://www.thingiverse.com/thing:13677) project.

This is the first project I have done where I did my best to follow the [OpenSCAD style guide](http://www.thingiverse.com/thing:12768) to the letter. However, when it came to writing comments, there is one thing I did differently: I combined module comments with ThingDoc comments where appropriate. If the module didn't represent a complete "thing" I didn't add any ThingDoc parameters.

In any parametric project, one has to make the difficult decision of which parameters affect other parameters. By the time I was done with this I realized everything revolves around (hehe) the arms. Because of this, I designed the script in such a way that if you change the radius of the arms (say, to beef them up a bit) the canopy, motor mounts, body will auto resize to match the new dimensions. I think this was the proper way to make it work, but I'm open to suggestions.
