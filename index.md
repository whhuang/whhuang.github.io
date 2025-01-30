---
layout: default
title: Home
---
# Hello!

I'd like to start tracking readership and interest, if you're reading this please take 5 seconds to fill this form out!

<div style="width:100%;height:500px;" data-fillout-id="vQMWybdq3Pus" data-fillout-embed-type="standard" data-fillout-inherit-parameters data-fillout-dynamic-resize></div><script src="https://server.fillout.com/embed/v1/"></script>


<h4 class="featured">Featured post<h4>
<div class="preview">
{% assign specific_post = site.posts | where: "slug", "getting-ready" | first %}
<div class="featured-title">
<a href="{{ site.baseurl }}{{ specific_post.url }}">{{ specific_post.title }}</a>
</div>
<p>{{ specific_post.excerpt }}</p>
<a href="{{ specific_post.url }}" class="read-more">read more...</a>
</div>
<br>
<h4 class="featured">Latest post<h4>
<div class="preview">
{% assign latest_post = site.posts | sort: 'date' | reverse | first %}
<div class="featured-title">
<h4>{{ latest_post.date | date: "%d %B %Y" }}</h4>
<a href="{{ site.baseurl }}{{ latest_post.url }}">{{ latest_post.title }}</a> ⏐
{% for category in latest_post.categories %}
<a href="/{{ category | slugify }}/" class="category">{{ category }}</a>{% unless forloop.last %}, {% endunless %}
{% endfor %}
</div>
<p>{{ latest_post.excerpt }}</p>
<a href="{{ latest_post.url }}" class="read-more">read more...</a>
</div>