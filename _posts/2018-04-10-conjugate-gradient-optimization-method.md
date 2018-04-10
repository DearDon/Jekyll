---
layout: post
title: conjugate gradient method
date: 2018-04-10 
categories: optimization
tags: machine-learning ;&nbsp; fortran 
 
--- 

### Abstract: 
Conjugate gradient method is one of the improved gradient algorithms for optimization. 
It's used to resolve linear system, which need to meet some strict requirements.
Though it's not a general solution for optimization problem, but it's quite **efficient** and **memory saving** for problems it fit.<br>

### Content:

#### Theory:
$$ A=A^T $$
<script src="https://gist.github.com/DearDon/c1a6a101e129a2afee71d31d6a4a2dfa.js?file=conjugate_gradient_theory.md"></script>

#### Numerical implemetation in Fortran:
##### Fortran subroutine for conjugate gradient:
<script src="https://gist.github.com/DearDon/c1a6a101e129a2afee71d31d6a4a2dfa.js?file=conjugate_gradient_method.f90"></script>
##### Conjugate gradient application:
<script src="https://gist.github.com/DearDon/c1a6a101e129a2afee71d31d6a4a2dfa.js?file=conjugate_gradient_example.f90"></script>

### Questions:
#### Is it adapt to deeplearning issue?
**No**. As we address above, it's adapted to linear system with extra requirements(symmetric and positive-definite) to coefficients matrix $A$. 
Wince deeplearning is non-linear structure, muchless the extra requrements, so the original conjugate gradient method is **not suitable** for deeplearning.
But there are some improvement that try to appply conjugate gradient to non-linear problem, but it may need more adjustments and tests to check if it could help on deeplearning training.
#### Is the error scale for measuring if training converge sensitive?
**Yes**. the error variable e in the code, which decide if loop converge, is quite sensitive. My own test shows set e=0.001 to e=1e-6 sometimes could improve much for the solution precision.
 
### History: 
* <em>2018-04-10</em>: create post for demonstration of conjugate gradient method 
