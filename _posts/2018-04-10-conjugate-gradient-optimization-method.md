---
layout: post
title: Conjugate Gradient Method
date: 2018-04-10 
categories: optimization
tags: data-science 
--- 
<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    tex2jax: {
      inlineMath: [ ['$','$'] ],
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
The conjugate gradient method is an algorithm for the numerical solution of particular systems of **linear equations**, namely those whose matrix $A$ is **symmetric** and **positive-definite**. 
For symmetric, it means:

$$A=A^T$$

For positive-definite, it means for any real value vector $x$, we can assure:

$$ x\mathbf{A}x^T>0 $$

We can see there are many preconditions for conjugate gradient method, but there are advantages. It require less memory than computing reverse $A^{-1}$ by Jacobi equation. And it can guarantee that only n iterations(n is the row or column of $A$, here we ignore computing error) are needed to converge the solution, which is far more faster and reliable than Newton gradient method.

The problem, which fit conjugate gradient method, could be expressed as following:

$$ \mathbf{A}x=b $$

where $A$ is a symmetric and positive-definite matrix, $x$ is the vector to be calculated, $b$ is the constant vector. Following is the computational steps for getting x(since it's systems of linear equation, initial $x_0$ could be any random value you like):

$$ 
\begin{align*}
r_0 &= b - Ax_0 \\
P_0 &= r_0 \\
k &= 0 \\
\end{align*}
$$


repeat:

$$ \alpha_k = \dfrac{r^T_kr_k}{p^T_kAp_k} $$

$$ x_{k+1} = x_k + \alpha_kp_k $$

$$ r_{k+1} = r_k - \alpha_kAp_k $$

if $r_{k+1}$ is sufficiently small, say $r_{k+1}^2<e$, then exist loop, else:

$$ \beta_k = \dfrac{r^T_{k+1}r_{k+1}}{r^T_kr_k} $$

$$ p_{k+1} = r_{k+1} + \beta_kp_k $$

$$ k=k+1 $$

end repeat

The final result is $x_{k+1}$. Above theory is derived from [wikipedia](https://en.wikipedia.org/wiki/Conjugate_gradient_method#Numerical_example).

#### 2. Numerical implemetation in Fortran:
##### 2.1. Fortran subroutine for conjugate gradient:

{% highlight fortran linenos %}
module conjugate_gradient_method
	contains 
!The following subroutine is the to get x from Ax=b by Conjugate Gradient
!N is the N_max ,this method is come from "矩阵计算的理论与方法"北大徐树方p154 
!with a little change
	subroutine cg(A,b,x,N)
	!variable	meaning
	!A		a matrix,from main program,is coefficient matrix of Ax=b
	!b		a vector,from main program,is righthand of Ax=b
	!x		a vector,the answer of Ax=b,is what we need,our goal
	!r		a vector,minus grads of 0.5xAx-bx at x point,says b-Ax
	!p		a vector,the direction of iteration better than r
	!w		a vector,value is A*p,is useful to simplify the process
	!q0		a number,value is r0*r0,is standard of loop times
	!q1		a number,value is rk-1*rk-1
	!q2		a number, value is rk*rk
	!ba,ar		a number,named by their pronounciation
	!e		a number,standard of loop times,input by client
	!test		a number,value is matmul(r,w)
	!pw		a number,value is matmul(p,w)
	!i		a number,count variable
	!N		a number,the degree of A
		real*8 A(N,N)
		real*8 b(N),x(N),r(N),p(N),w(N)
		!real*8 A(2,2),b(2),x(2),r(2),p(2),w(2)
		real*8 q0,q1,q2,ba,ar,e,test,pw
		integer i,N
	!	write(*,*)"you want the x_error less than"
	!	read(*,*)e
	!	write(*,*)"you want x0 to be?"
	!	read(*,*)x
		e=0.01d0
		r=b-matmul(a,x)
		call onedimenmul(r,r,N,q0)
		q2=q0
		p=r

	!	w=matmul(A,p)
	!	call onedimenmul(r,w,2,test)
	!	ar=q2/test
	!	x=x+ar*p
	!	r=r-ar*w
	!	q1=q2;call onedimenmul(r,r,2,q2)
	!	!r=r-a*w
		i=1
	write(*,"(5f13.6,i13)")2*x(1)**2+x(2)**2-x(1)*x(2),x,r,i
	
		do while(q2>=e)
		q1=q2
	!	ba=q2/q1
	!	p=r+ba*p
		
		w=matmul(A,p)
		call onedimenmul(p,w,N,pw)!pw is p*w
		ar=q1/pw
		x=x+ar*p
		r=r-ar*w
		call onedimenmul(r,r,N,q2)
		!r=r-a*w
		ba=q2/q1
		i=i+1
		p=r+ba*p
	write(*,"(5f13.6,i13)")2*x(1)**2+x(2)**2-x(1)*x(2),x,r,i
	
		end do
!	write(*,*)"x",x
!	write(*,*)"i",i
	end subroutine cg

	!This subroutine is to solve one dimention's multiplication
	subroutine onedimenmul(m1,m2,n,ans)
	integer n
	real*8 m1(n),m2(n),ans
	ans=0
	do i=1,n
		ans=m1(i)*m2(i)+ans
	end do
	
	end subroutine onedimenmul
end module conjugate_gradient_method
{% endhighlight %}

##### 2.2. Conjugate gradient application:
{% highlight fortran linenos %}
program conjugate_gradient_example
	use conjugate_gradient_method
	real*8 x(2),A(2,2),b(2)
	integer n
	write(*,"(6A13)")"f","x1","x2","g1","g2","i"
	data a /4.0d0,-1.0d0,-1.0d0,2.0d0/
	data b/0.0d0,0.0d0/
	data x/1.0d0,1.0d0/
	n=2
	call cg(A,b,x,n)
end program conjugate_gradient_example
{% endhighlight %}

### Questions:
#### 1. Is it adapt to deeplearning issue?
**No**. As we address above, it's adapted to linear system with extra requirements(symmetric and positive-definite) to coefficients matrix $A$. 
Wince deeplearning is non-linear structure, muchless the extra requrements, so the original conjugate gradient method is **not suitable** for deeplearning.
But there are some improvement that try to appply conjugate gradient to non-linear problem, but it may need more adjustments and tests to check if it could help on deeplearning training.
#### 2. Is the error scale for measuring if training converge sensitive?
**Yes**. the error variable $e$ in the code, which decide if loop converge, is quite sensitive. My own test case shows change $e=1.0\times10^{-3}$ to $e=1.0\times10^{-6}$ could improve very much for the solution precision.
 
### History: 
* <em>2018-04-10</em>: create post for demonstration of conjugate gradient method 

