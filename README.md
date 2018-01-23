# Salient Poses

[![build status](https://travis-ci.org/richard-roberts/PhD.svg?branch=master)](https://travis-ci.org/richard-roberts/PhD)

*Note: this is a work in progress, this documentation reflects my goal for the project rather than its current state.*

The Salient Poses algorithm is a three-step process designed primarily for converting *hard-to-edit* motion capture into *easy-to-edit* keyframe animation. In terms of keyframes, the resulting animation is structured to be similar to a [blocked animation](https://en.wikipedia.org/wiki/Blocking_(animation)) that might have otherwise been hand-crafted by an animator, while still preserving the detail of the original performance.

Using the Salient Poses algorithm, an artist can load in a motion capture animation, choose the parts of the animation that are most indicative of the keyframes that they want to use, and then apply the algorithm (steps one and two) to produce a range of possible reductions - expressed as a range of selections of keyframes, each with a different level of compression. Once the artist has found a level of compression that best suits their task, they apply the algorithm (step three) to create a new simplified animation. The simplified animation contains only the keyframes in the selection chosen by the artist. With the new and simplified animation, the artist can make changes to the motion as though it were a blocked animation. 

*Note: video coming soon*

See the [Details](#details) section for more information about the algorithm, the [Contents](#contents) section for an introduction to the four different implementations presented here (some of which are under active development), the [Installation](#installation) section for information about downloading and setting up each implementation, and finally the [Contributing](#contributing) section for more information about how to contribute. 

Researchers may be interested to see the [write-up](https://richard-roberts.github.io/PhD/) about this project, and also the [Academic Work](#academic-work) section that presents my plans to publish on this topic. 


Details
-------

These details provide an overview of the algorithm, please contact me directly for more information or, if you dare, refer to my [PhD thesis](http://researcharchive.vuw.ac.nz/handle/10063/6924) on the topic.

The three steps of the algorithm are as follows:

1. Analysis - analyze the motion using a *criteria for keyframe selection*,
2. Selection - create many selections of keyframes,
3. Reduction - create a new animation using only one set of keyframes.

Each of the steps are simple to implement, but require some explanation. The purpose of the analysis step is to prepare a table of information, lets call this the **Analysis Table** that will be used for the second "Selection" step. The table is a matrix, where each cell contains a scalar value that expresses how well a pair of keyframes (indexed by the row and column) summarize the motion. With the constraint that the cell contains a scalar value, we can set any criteria for keyframe selection by designing a function that maps from different slices of the animation to an value - typically an error measurement, although any other type of value is possible. For example, the cell at row 10 and column 50 might express the distance between the slice of animation from frames 10 to 50 and a spline interpolation of frames 10 and 50; with this interpolation-distance based criteria, the table contains information about how easily each pair of keyframes can be interpolated to recreate the animation. 

With the Analysis Table available, we can create a range of selections of keyframes. This second selection step uses a restricted interpretation of [Dijkstra's algorithm](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm) to ensure that every one of these selections is **optimal** (every selection either minimizes or maximizes the total of the values given by the Analysis Table). The second step generates each selection iteratively: it first creates a selection of two keyframes (the first and last frames in the animation), another containing three keyframes, another containing four keyframes, with the last set containing every frame in the original animation (all frames are selected as keyframes). The selections are stored into another table, a triangular matrix, which I call the **Selection Table**.

Finally, we can choose a selection from the Selection Table and then apply the third reduction step to create a new animation. To create the animation, we first create a copy of the original motion capture animation, remove all non-keyframes from the copy, and then tweak the interpolation of the remaining keyframes to best approximate the original animation. As with any data-reduction, the new and simplified animation loses some of the detail of the original; however, in my experience, for motion capture recorded at 120 frames per second, I can reach between 90-95\% compression before the simplified animation appears distorted. 

As mentioned above, the new animation is structured in a way that is similar to hand-crafted animation after the blocking stage. Because of this structuring, in terms of keyframes, an artist can edit the animation in much the same way as hand-crafted keyframe animation.


Contents
--------

This repository contains for implementations of the Salient Poses algorithms:

1. [SalientPosesReference](https://github.com/richard-roberts/SalientPosesReference/) - a reference implementation developed in Python.
2. [SalientPosesPerformance](https://github.com/richard-roberts/SalientPosesPerformance/) - performance implementation developed in C++.
3. [SalientPosesMaya](https://github.com/richard-roberts/SalientPosesMaya/) - an in-development Maya plug-in, containing the algorithm and an interface for using it.


Getting Started
---------------

Please see the "Getting Started" section of the implementation you wish to get started with:

1. [SalientPosesReference](https://github.com/richard-roberts/SalientPosesReference/#GettingStarted)
2. [SalientPosesPerformance](https://github.com/richard-roberts/SalientPosesPerformance/#GettingStarted)
3. [SalientPosesMaya](https://github.com/richard-roberts/SalientPosesMaya/#GettingStarted)


Contributing
------------

*Note: Coming soon.*

Please note that the license attached to this repository permits both personal and commercial use of this software, however any changes or extension to this software must be redistributed alike (under the same license). 


Testing
-------

*Note: Coming soon.*


Academic Work
-------------

- **Good Compression; Better Editing** - a technical brief planned for submission to [SIGGRAPH Asia 2018](https://sa2018.siggraph.org/), a top-tier Computer Graphics conference hosted in Tokyo, Japan later this year.

- [Converting Motion Capture Into Editable Keyframe Animation: Fast, Optimal, and Generic Keyframe Selection](http://researcharchive.vuw.ac.nz/handle/10063/6924) - my PhD thesis, published February, 2018.


Other Interesting Work
----------------------

- Ongoing, [soswow's implementation](https://github.com/soswow/fit-curve) of Schneider's curve fitting algorithm (described in [Comparison](#comparison)).

- 2015, Richard Frazer's [implementation](http://richardfrazer.com/tools-tutorials/keyframe-reduction-script-for-nuke/) of [Lim and Thalmann](http://ieeexplore.ieee.org/document/1020399/)'s greedy-based keyframe selection algorithm.

- 2013, A keyframe decimation approach by [Fabrizio Nunnari and Alexis Heloir](https://slsi.dfki.de/2013/06/05/simplify-multiple-f-curves-blender-addon-released/), with an [implementation available](http://www.dfki.de/~fanu01/simplify_multiple_f-curves/SimplifyMultipleFCurves-v1_1.py).

- 2011, Benjy Cook's [Motion Capture Addon](https://wiki.blender.org/index.php/User:Benjycook/GSOC/Manual) for Blender. A [YouTube tutorial](https://www.youtube.com/watch?v=_VhbSrau-0c&t=428s) series is available. 

- Machinimatrix's discussion on "Lowes Local" and "Lowes Global" in their [blog post](https://blog.machinimatrix.org/avastar/using-bvh-and-mocap/).

- Ongoing, Maya's [Simplify Curves](http://download.autodesk.com/global/docs/maya2014/en_us/index.html?url=files/Keyframe_Animation_Simplify_curves.htm,topicNumber=d30e249923) tool.

- Ongoing, Blender's [Curve Simplify](https://wiki.blender.org/index.php/Extensions:2.6/Py/Scripts/Curve/Curve_Simplify) operator.


Who is this for
---------------

I interned with [Weta Digital](https://www.wetafx.co.nz/) and [OLM Digital](https://olm.co.jp/) during my time as student. Whilst there I noticed that motion editing and the hand-crafted animation pipelines were rarely integrated, which, at least in my opinion, is a missed opportunity - animators can use motion capture as a pre-visualization tool and motion editors can use animation techniques to better stylize motion capture. I designed the Salient Poses algorithm to bride this gap and, more importantly, to help visual effects artists and hobbyists enjoy using motion capture just that little bit more.
