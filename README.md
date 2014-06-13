Computer Vision Assignment
===========================

Computer Vision Assignment. University of Amsterdam. 2014.

This repository contains the implementations for the Computer Vision
assignments. There are 3 assignments located in Assignment1/, Assignment2/, and
Assignment3/ directories. Go to the src/ directory of each assignment folder to
run the script.

## Author
Yikang Wang
Arif Qodari


How to use
--

### Assignment 1 - ICP

#### Basic ICP

We can simply run the basic ICP implementation by running this following
command:

    [R, t, Tr, S_homo, T_homo] = ICP(S, T, TOL, TIME, Tr)

    * S is source point cloud
    * T is target point cloud
    * TOL is minimum tolerance value
    * TIME is maximum iteration
    * Tr is initial transformation matrix

    It will return these following values:

    * R is rotation matrix
    * t is translation vector
    * Tr is transformation matrix (combined rotation matrix and translation
      vector)
    * S_homo is source point cloud in homogeneous coordinates
    * T_homo is target point cloud in homogeneous coordinates
    * 

#### Merging Scene - Scenario 1

We can simply run the basic first merging scenario by running this following
command:

    [points_merged, runtime] = merge_orderly(interval, TOL, TIME)
        
        * interval is the number of interval images that will be merged

#### Merging Scene - Scenario 2

We can simply run the basic second merging scenario by running this following
command:

    [merged_points, runtime] = experiment2()

### Assignment 2

### Assignment 3
