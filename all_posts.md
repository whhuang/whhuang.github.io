---
layout: default
title: All posts
---
# All posts

Classic blog feed display style that shows all posts in reverse-chronological order. The blog isn't intended to be read this way (using the categories on the side is preferred), but could be helpful for keeping up-to-date easily. I'll probably add sorting options at some point.

<div>
{% for post in site.posts %}
    <div class="date">{{ post.date | date: "%d %B %Y" }} ⏐
    {% for category in post.categories %}
    <a href="/{{ category | slugify }}/" class="category">{{ category }}</a>{% unless forloop.last %}, {% endunless %}
    {% endfor %}
    </div>
    <h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
    <div class="preview">
    {{ post.excerpt }}
    <a href="{{ post.url }}" class="read-more">read more...</a>
    </div>
    <br>
{% endfor %}
</div>
