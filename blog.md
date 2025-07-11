---
layout: blog
title: "Blog"
permalink: /blog/
---
<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
      <span>{{ post.date | date: "%B %d, %Y" }}</span>
    </li>
  {% endfor %}
</ul>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Malcolm Soto – Blog</title>
  <style>
    :root {
      --bg-light: #ffffff;
      --bg-dark: #121212;
      --text-light: #000000;
      --text-dark: #f0f0f0;
      --button-light: #1e90ff;
      --button-dark: #4c9aff;
    }
    body {
      margin: 0;
      font-family: system-ui, sans-serif;
      background-color: var(--bg-light);
      color: var(--text-light);
      text-align: center;
      padding: 2rem 1rem;
      transition: background 0.3s, color 0.3s;
      position: relative;
    }
    [data-theme="dark"] body {
      background-color: var(--bg-dark);
      color: var(--text-dark);
    }
    h1 {
      font-size: 2.5rem;
      margin-bottom: 0.5rem;
    }
    p {
      max-width: 700px;
      margin: 0 auto 1rem auto;
      line-height: 1.6;
    }
    a {
      color: var(--button-light);
      text-decoration: none;
    }
    [data-theme="dark"] a {
      color: var(--button-dark);
    }
    .button {
      display: inline-block;
      margin-top: 1rem;
      padding: 0.75rem 1.5rem;
      font-size: 1rem;
      background-color: var(--button-light);
      color: white;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      text-decoration: none;
    }
    [data-theme="dark"] .button {
      background-color: var(--button-dark);
      color: white;
    }
    .toggle {
      position: absolute;
      top: 1rem;
      right: 1rem;
      padding: 0.5rem 0.9rem;
      font-size: 0.9rem;
      background: transparent;
      border: 2px solid #ccc;
      border-radius: 6px;
      cursor: pointer;
      color: inherit;
    }
    nav {
      display: flex;
      justify-content: center;
      flex-wrap: wrap;
      gap: 1rem;
      margin-bottom: 2rem;
    }
    article {
      max-width: 700px;
      margin: 2rem auto;
      text-align: left;
    }
    article h3 {
      margin-bottom: 0.2rem;
    }
    article p.meta {
      margin: 0;
      color: gray;
      font-size: 0.9rem;
    }
    footer {
      font-size: 0.85rem;
      margin-top: 4rem;
      color: gray;
    }
  </style>
</head>
<body>
  <script>
    const toggleTheme = () => {
      const html = document.documentElement;
      const newTheme = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
      html.setAttribute('data-theme', newTheme);
      localStorage.setItem('theme', newTheme);
    };
    window.addEventListener('DOMContentLoaded', () => {
      const savedTheme = localStorage.getItem('theme') || 'light';
      document.documentElement.setAttribute('data-theme', savedTheme);
    });
  </script>

  <button class="toggle" onclick="toggleTheme()">Toggle Light/Dark Mode</button>

  <!-- 🧭 Navigation Bar -->
  <nav>
    <a href="{{ "/" | relative_url }}" class="button">Home</a>
    <a href="/blog/" class="button">Blog</a>
    <a href="mailto:malcolmittech@gmail.com" class="button">Contact</a>
    <a href="https://www.linkedin.com/in/malcolm-soto/" target="_blank" class="button">LinkedIn</a>
  </nav>

  <main>
    <h1>📝 Blog</h1>
    <p>Thoughts, tutorials, and tips from Malcolm Soto</p>

    {% for post in site.posts %}
      <article>
        <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
        <p class="meta">{{ post.date | date: "%B %d, %Y" }}</p>
        <p>{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
      </article>
    {% endfor %}
  </main>

  <footer>
    <p>© 2025 Malcolm Soto | AWS Certified Consultant | Houston, TX</p>
    <p>Hosted in: <strong>AWS CloudFront</strong></p>
  </footer>
</body>
</html>
