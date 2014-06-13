Computer Vision Assignment
===========================

Computer Vision Assignment. University of Amsterdam. 2014.

This repository contains the implementations for the Computer Vision assignments. There are 3 assignments located in Assignment1/, Assignment2/, and Assignment3/ directories. Go to the src/ directory of each assignment folder to run the script.

## Author
Yikang Wang

Arif Qodari


How to use
--

### Assignment 1 - ICP

#### Basic ICP

We can simply run the basic ICP implementation by running this following command:

    [R, t, Tr, S_homo, T_homo] = ICP(S, T, TOL, TIME, Tr)

* S is source point cloud
* T is target point cloud
* TOL is minimum tolerance value
* TIME is maximum iteration
* Tr is initial transformation matrix

It will return these following values:

* R is rotation matrix
* t is translation vector
* Tr is transformation matrix (combined rotation matrix and translation vector)
* S_homo is source point cloud in homogeneous coordinates
* T_homo is target point cloud in homogeneous coordinates

#### Merging Scene - Scenario 1

We can simply run the first merging scenario by running this following command:

    [points_merged, runtime] = merge_orderly(interval, TOL, TIME)
        
* interval is the number of interval images that will be merged

#### Merging Scene - Scenario 2

We can simply run the second merging scenario by running this following command:

    [merged_points, runtime] = experiment2()

### Assignment 2
We can simply run the chaining procedure by running this following command:

    [M,PVM] = chaining(foldername)
    [M,PVM] = chaining(foldername, 'ransac')

* foldername is the data to use, it can be either ``TeddyBear`` or ``House``
* 'ransac' it the parameter, specifying whether to use the Ransac method

It will return the following values:
* M is the patch view matrix for visualization
* PVM is the patch view matrix with a special format, which can be parse by the code in the first part of assignment 3.
### Assignment 3

#### Structure from Motion
Once we obtain Point View Matrix from the Assignment 2, we can estimate 3D structure buy running the main function. Run this following command from the src/ directory:

    main(PVM)

While PVM is the obtained point view matrix. This script will show all  partial 3D structures from each point of view.
