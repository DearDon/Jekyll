---
layout: post
title: Plot Kmeans Assumptions
date: 2017-08-13 
categories: scikit-learn
tags: machine-learning ; clustering 
 
--- 
 
### Abstract:
This example is meant to illustrate situations where k-means will produce
`unintuitive` and `possibly unexpected` clusters.<br> 
 
### Content:  
In the first three row plots, the input data does not conform to some implicit
assumption that k-means makes and
undesirable clusters are produced as a result. In the last plot, k-means returns
intuitive clusters despite unevenly sized blobs. 
 
For each row, left imange is the result from k-means, right is the data we
generated, which you can treat as the real cluster. The code below is based on
[sklearn web](http://scikit-
learn.org/stable/auto_examples/cluster/plot_kmeans_assumptions.html#sphx-glr-
auto-examples-cluster-plot-kmeans-assumptions-py). 

**In [1]:**

{% highlight python linenos %}
%matplotlib inline

print(__doc__)

# Author: Phil Roth <mr.phil.roth@gmail.com>
# License: BSD 3 clause

import numpy as np
import matplotlib.pyplot as plt

from sklearn.cluster import KMeans
from sklearn.datasets import make_blobs


n_samples = 1000
random_state = 150

X, y = make_blobs(n_samples=n_samples, random_state=random_state)
{% endhighlight %}

    Automatically created module for IPython interactive environment


**In [2]:**

{% highlight python linenos %}
# Incorrect number of clusters
y_pred = KMeans(n_clusters=2, random_state=random_state).fit_predict(X)

plt.figure(figsize=(12, 4))

plt.subplot(121)
plt.scatter(X[:, 0], X[:, 1], c=y)
plt.title("Real Data Set")

plt.subplot(122)
plt.scatter(X[:, 0], X[:, 1], c=y_pred)
plt.title("Incorrect Number of Blobs")

plt.show()
{% endhighlight %}

 
![png](/assets/2017-08-13-plot-kmeans-assumptions_files/2017-08-13-plot-kmeans-assumptions_8_0.png) 


**In [3]:**

{% highlight python linenos %}
# Anisotropicly distributed data
transformation = [[ 0.60834549, -0.63667341], [-0.40887718, 0.85253229]]
X_aniso = np.dot(X, transformation)
y_pred = KMeans(n_clusters=3, random_state=random_state).fit_predict(X_aniso)

plt.figure(figsize=(12, 4))

plt.subplot(121)
plt.scatter(X_aniso[:, 0], X_aniso[:, 1], c=y)
plt.title("Real Data Set")

plt.subplot(122)
plt.scatter(X_aniso[:, 0], X_aniso[:, 1], c=y_pred)
plt.title("Anisotropicly Distributed Blobs")

plt.show()
{% endhighlight %}

 
![png](/assets/2017-08-13-plot-kmeans-assumptions_files/2017-08-13-plot-kmeans-assumptions_9_0.png) 


**In [4]:**

{% highlight python linenos %}
# Different variance
X_varied, y_varied = make_blobs(n_samples=n_samples,
                                cluster_std=[1.0, 2.5, 0.5],
                                random_state=random_state)
y_pred = KMeans(n_clusters=3, random_state=random_state).fit_predict(X_varied)

plt.figure(figsize=(12, 4))

plt.subplot(121)
plt.scatter(X_varied[:, 0], X_varied[:, 1], c=y)
plt.title("Real Data Set")

plt.subplot(122)
plt.scatter(X_varied[:, 0], X_varied[:, 1], c=y_pred)
plt.title("Unequal Variance")

plt.show()
{% endhighlight %}

 
![png](/assets/2017-08-13-plot-kmeans-assumptions_files/2017-08-13-plot-kmeans-assumptions_10_0.png) 


**In [5]:**

{% highlight python linenos %}
# Unevenly sized blobs
X_filtered = np.vstack((X[y == 0][:500], X[y == 1][:100], X[y == 2][:10]))
y_pred = KMeans(n_clusters=3, random_state=random_state).fit_predict(X_filtered)

plt.figure(figsize=(12, 4))

plt.subplot(121)
y_filtered = np.concatenate((y[y == 0][:500], y[y == 1][:100], y[y == 2][:10]), axis=0)
plt.scatter(X_filtered[:, 0], X_filtered[:, 1], c=y_filtered)
plt.title("Real Data Set")

plt.subplot(122)
plt.scatter(X_filtered[:, 0], X_filtered[:, 1], c=y_pred)
plt.title("Unevenly Sized Blobs")

plt.show()
{% endhighlight %}

 
![png](/assets/2017-08-13-plot-kmeans-assumptions_files/2017-08-13-plot-kmeans-assumptions_11_0.png) 

 
### Questions: 
 
### History: 
* <em>2017-08-13</em>: create post for demonstration of k-means assumption 
