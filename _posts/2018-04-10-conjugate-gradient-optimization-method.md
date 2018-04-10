---
layout: post
title: Conjugate Gradient Method
date: 2018-04-10 
categories: optimization
tags: machine-learning ;&nbsp; fortran 
--- 
<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    tex2jax: {
      inlineMath: [ ['$','$'], ["\\(","\\)"] ],
      processEscapes: true
    }
  });
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/MathJax.js?config=TeX-AMS-MML_HTMLorMML" type="text/javascript"></script>

### Abstract: 
Conjugate gradient method is one of the improved gradient algorithms for optimization. 
It's used to resolve linear system, which need to meet some strict requirements.
Though it's not a general solution for optimization problem, but it's quite **efficient** and **memory saving** for problems it fit.<br>

### Content:
#### 1. Theory:
<script src="https://gist.github.com/DearDon/c1a6a101e129a2afee71d31d6a4a2dfa.js?file=conjugate_gradient_theory.md"></script>

#### 2. Numerical implemetation in Fortran:
##### 2.1. Fortran subroutine for conjugate gradient:
<script src="https://gist.github.com/DearDon/c1a6a101e129a2afee71d31d6a4a2dfa.js?file=conjugate_gradient_method.f90"></script>
##### 2.2. Conjugate gradient application:
<script src="https://gist.github.com/DearDon/c1a6a101e129a2afee71d31d6a4a2dfa.js?file=conjugate_gradient_example.f90"></script>

### Questions:
#### 1. Is it adapt to deeplearning issue?
**No**. As we address above, it's adapted to linear system with extra requirements(symmetric and positive-definite) to coefficients matrix $A$. 
Wince deeplearning is non-linear structure, muchless the extra requrements, so the original conjugate gradient method is **not suitable** for deeplearning.
But there are some improvement that try to appply conjugate gradient to non-linear problem, but it may need more adjustments and tests to check if it could help on deeplearning training.
#### 2. Is the error scale for measuring if training converge sensitive?
**Yes**. the error variable $e$ in the code, which decide if loop converge, is quite sensitive. My own test case shows change $e=0.001$ to $e=1e-6$ could improve very much for the solution precision.
 
### History: 
* <em>2018-04-10</em>: create post for demonstration of conjugate gradient method 

