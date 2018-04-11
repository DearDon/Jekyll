---
layout: post
title: Highlight Code in Jekyll
date: 2017-08-12 
categories: trial&error
tags: service
--- 
 
### Abstract:
 
I demostrate how I highlight the code in my `jekyll v3.*` post by rouge.<br> 
 
### Content:
 
Code is the most usual block we record for a technical blog. However code
without good highlight and format is a mess for reading. 
 
Old version of jekyll use redcarpet by default, and use pygments to highlight
code. Since Jekyll upgrade to v3.\*, it only suppport kramdown.
Now github has udpate jekyll to v3.\*, so GitHub Pages only supports Rouge as
code highlighter. 
 
According to <https://sacha.me/articles/jekyll-rouge/>, the easiest way to use
Rouge is using the kramdown markdown parser. They recently added native support
for Rouge and Jekyll has been supporting kramdown for a while now.<br> 
 
#### 1. Install
 
First, make sure you’re using a recent version of Jekyll (for example 2.5.0).
You can check your installed version using `jekyll -v`. 
 
Next up, you need to install kramdown and Rouge. 
 
    gem install kramdown rouge 
 
If you already have a version of kramdown on your machine, make sure it’s at
least on version 1.5.0. <br>
If you’ve followed these steps so far you’re now ready to use kramdown and Rouge
within your Jekyll setup.<br>
By the way, if, like me, you’re always getting errors doing anything with Rouge,
remember it’s called Rouge, not Rogue. 
 
#### 2. Setting 
 
##### 2.1. setting in _config.yml 
 
As with all options concerning your builds, the place to add them is in your
`_config.yml`. 
 
You might have an entry like highlighter: pygments in there, make sure to remove
that. 
 
According to virtua's [page](http://blog.virtuacreative.com.br/upgrade-
jekyll-2-to-3-gh-pages.html). If you used pygments before, don’t worry, Rouge is
fully compatible with it. So, the only thing to do is changing your _config.yml,
making sure it has: 
 
    markdown: kramdown

    kramdown:
      input: GFM
      syntax_highlighter: rouge 
 
Or for jekyll3: 
 
    markdown: kramdown

    kramdown:
      input: GFM
    highlighter: rouge 
 
If you want to display line numbers on every code block, you can easily do that
by adding this line to your _config.yml: 
 
    line_numbers: true 
 
Or you can use linenos to set line for each block. We'll show an example later. 
 
##### 2.2. generate css style file 
 
You need to use a css file to manage your syntax style for jekyll page. <br>
To generate such syntax.css file, you need choose a style. You can get all
availables by: 
 
    rougify help style 
 
Then choose one to generate css file, take monokai style for example. In your
jekyll bolg root path: 
 
    rougify style monokai > css/syntax.css 
 
Add css file setting to you layout file _layouts/default.html: 
 
    <!-- Syntax CSS -->
        <link href="/css/syntax.css" rel="stylesheet"> 
 
Now, all setting's done!!! 
 
#### 3. Usage 
 
With Rouge, you won’t need Python installed locally to work on your Jekyll site.
It is fully written in Ruby. It also provides full backtick support for
highlighting your code. 
 
No only you can do with writing the usual highlight: 
{% raw %}
    {% highlight %} 
    ...code...
    {% endhighlight %}
{% endraw %} 
You can do the same with backticks: 
{% raw %}
    ```html
    ...code...
    ```
{% endraw %} 
And you can also add line numbers: 
 
{% highlight ruby linenos %}
def foo
  puts 'foo'
end
{% endhighlight %} 
 
with the standard highlight markup: 
{% raw %}
    {% highlight ruby linenos %}
    def foo
      puts 'foo'
    end
    {% endhighlight %}
{% endraw %} 
Note that both highlight and backticks are fully supported by Rouge. 
 
### Questions:
 
#### 1. code highlight without color 
 
I've encounted a problem that highlight just didn't work after all setting and
installation are done.It turn out to be a quite easy issue. Just lack of css
file to tell highlight which color style should be used!!<br>
So if you have the same problem, just generate the css file for your page. 
 
Please get details from the post for generate syntax.css file!! 
 
### History:
 
* <em>2017-08-12</em>: create post for recording how to highlight code syntax in
jekyll post by rouge, including install, setting and usage. 
