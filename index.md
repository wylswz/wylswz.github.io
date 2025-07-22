---
layout: default
---


![xm](/assets/xmcover.png)



## Technical Taolus

{% assign articles = site.pages | where_exp: "page", "page.path contains '.md'" | where_exp: "page", "page.path != 'index.md'" | where_exp: "page", "page.path != 'README.md'" %}
{% for article in articles %}
{% assign path_parts = article.path | split: '/' %}
{% assign parent = path_parts[0] | capitalize %}
{% assign title = path_parts[-1] | remove: '.md' | capitalize %}
- [{{ parent }} / {{ title }}]({{ article.url }})
{% endfor %}



## Resume

[enUS](./resume/enUS.md)

<style>
    table {
        width:100%;    
    }
</style>
