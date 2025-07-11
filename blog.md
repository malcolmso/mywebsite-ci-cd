---
layout: blog
title: "Blog"
permalink: /blog/
---
{% for post in site.posts %}
<h2>{{ post.title }}</h2>
<p>{{ post.date | date: "%B %d, %Y" }}</p>
<p>{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
{% endfor %}
