/* reader.js — in-browser Markdown viewer for lesson.html */
(function () {
  'use strict';

  const root   = document.documentElement;
  const params = new URLSearchParams(window.location.search);
  const rawFile = params.get('file') || '';

  /* ── Resolve doc URL regardless of server root ───────────
     ALL_LESSONS stores paths like "../docs/..." relative to web/.
     When lesson.html is served at /web/lesson.html this works fine.
     When Live Server serves web/ as root, lesson.html is at /lesson.html
     and "../docs/" goes above the server root → 404.
     We detect the page's position and strip the leading "../" when needed.
  ─────────────────────────────────────────────────────────── */
  function resolveDocUrl(url) {
    if (!url) return url;
    // If our page is inside a /web/ path segment, relative paths work normally.
    if (window.location.pathname.includes('/web/')) return url;
    // Otherwise (server root = web/), strip one leading "../"
    return url.replace(/^\.\.\//, '');
  }

  /* ── theme helpers ──────────────────────────────────── */
  function applyHljsTheme(dark) {
    const el = document.getElementById('hljsTheme');
    if (!el) return;
    el.href = dark
      ? 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css'
      : 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github.min.css';
  }
  applyHljsTheme(root.dataset.theme === 'dark');

  /* sync theme toggle to also swap hljs stylesheet */
  document.getElementById('themeToggle')?.addEventListener('click', () => {
    setTimeout(() => applyHljsTheme(root.dataset.theme === 'dark'), 0);
  });

  /* ── mermaid init ───────────────────────────────────── */
  const isDark = root.dataset.theme === 'dark';
  if (window.mermaid) {
    mermaid.initialize({ startOnLoad: false, theme: isDark ? 'dark' : 'default', securityLevel: 'loose' });
  }

  /* ── marked renderer (handles mermaid + hljs) ────────── */
  if (window.marked) {
    marked.use({
      gfm: true,
      breaks: false,
      renderer: {
        code: function (token) {
          /* marked v12 passes a token object; older versions pass (code, lang) */
          var text = (typeof token === 'object') ? (token.text || '') : token;
          var lang = (typeof token === 'object') ? (token.lang || '') : (arguments[1] || '');
          lang = (lang || '').trim().toLowerCase();

          /* Mermaid diagrams */
          if (lang === 'mermaid') {
            return '<div class="mermaid-wrap"><div class="mermaid">' + escHtml(text) + '</div></div>';
          }

          /* Syntax-highlighted code */
          var hlLang = (window.hljs && hljs.getLanguage(lang)) ? lang : 'plaintext';
          var highlighted = text;
          try {
            if (window.hljs) highlighted = hljs.highlight(text, { language: hlLang }).value;
          } catch (e) {
            highlighted = escHtml(text);
          }
          return (
            '<div class="code-block-wrap">' +
              '<span class="lang-tag">' + escHtml(lang || 'code') + '</span>' +
              '<button class="copy-btn" type="button">Copy</button>' +
              '<pre class="code-block"><code class="hljs language-' + hlLang + '">' + highlighted + '</code></pre>' +
            '</div>'
          );
        }
      }
    });
  }

  function escHtml(s) {
    return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
  }

  /* ── helpers ────────────────────────────────────────── */
  function slugify(text) {
    return text.toLowerCase()
      .replace(/<[^>]+>/g, '')
      .replace(/[^\w\s-]/g, '')
      .replace(/\s+/g, '-')
      .replace(/-+/g, '-')
      .trim() || ('h' + Math.random().toString(36).slice(2, 6));
  }

  /* ── TOC builder ────────────────────────────────────── */
  function buildTOC() {
    const headings = document.querySelectorAll('#markdownContent h1, #markdownContent h2, #markdownContent h3');
    const tocNav   = document.getElementById('tocNav');
    if (!tocNav || !headings.length) return;

    const items = [];
    headings.forEach(function (h, i) {
      if (!h.id) h.id = slugify(h.textContent) + '-' + i;
      items.push({ level: parseInt(h.tagName[1]), id: h.id, text: h.textContent.trim() });
    });

    tocNav.innerHTML = items.map(function (item) {
      return '<a href="#' + item.id + '" class="toc-item toc-h' + item.level + '" title="' + item.text + '">' + item.text + '</a>';
    }).join('');

    /* Scroll-spy */
    if ('IntersectionObserver' in window) {
      const links = tocNav.querySelectorAll('.toc-item');
      const io = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            links.forEach(function (a) { a.classList.remove('active'); });
            var active = tocNav.querySelector('[href="#' + entry.target.id + '"]');
            if (active) active.classList.add('active');
          }
        });
      }, { rootMargin: '-15% 0px -75% 0px' });
      headings.forEach(function (h) { io.observe(h); });
    }
  }

  /* ── Section-nav builder ─────────────────────────────── */
  function buildSectionNav(currentUrl) {
    var lessons = window.ALL_LESSONS || [];
    var norm    = function (u) { return decodeURIComponent(resolveDocUrl(u)).replace(/\\/g, '/'); };
    var current = lessons.find(function (l) { return norm(l.url) === norm(currentUrl); });
    if (!current) return;

    var sectionLessons = lessons.filter(function (l) { return l.section === current.section; });
    var sectionNav     = document.getElementById('sectionNav');
    if (!sectionNav) return;

    sectionNav.innerHTML = sectionLessons.map(function (l) {
      var active = norm(l.url) === norm(currentUrl);
      return '<a href="lesson.html?file=' + encodeURIComponent(l.url) + '"' +
             ' class="section-nav-item' + (active ? ' active' : '') + '"' +
             ' title="' + l.title + '">' +
             l.number + '. ' + l.title + '</a>';
    }).join('');
  }

  /* ── Prev / Next builder ─────────────────────────────── */
  function buildPrevNext(currentUrl) {
    var lessons = window.ALL_LESSONS || [];
    var norm    = function (u) { return decodeURIComponent(resolveDocUrl(u)).replace(/\\/g, '/'); };
    var idx     = lessons.findIndex(function (l) { return norm(l.url) === norm(currentUrl); });
    if (idx === -1) return;

    var prev = lessons[idx - 1];
    var next = lessons[idx + 1];

    var prevBtn  = document.getElementById('prevBtn');
    var nextBtn  = document.getElementById('nextBtn');
    var prevLink = document.getElementById('prevLink');
    var nextLink = document.getElementById('nextLink');
    var prevTitle= document.getElementById('prevTitle');
    var nextTitle= document.getElementById('nextTitle');
    var nav      = document.getElementById('prevNextNav');
    if (nav) nav.style.display = 'flex';

    if (prev) {
      var pHref = 'lesson.html?file=' + encodeURIComponent(prev.url);
      if (prevLink) { prevLink.href = pHref; prevLink.style.visibility = ''; }
      if (prevTitle) prevTitle.textContent = prev.title;
      if (prevBtn)   prevBtn.onclick = function () { location.href = pHref; };
    }
    if (next) {
      var nHref = 'lesson.html?file=' + encodeURIComponent(next.url);
      if (nextLink) { nextLink.href = nHref; nextLink.style.visibility = ''; }
      if (nextTitle) nextTitle.textContent = next.title;
      if (nextBtn)   nextBtn.onclick = function () { location.href = nHref; };
    }
  }

  /* ── Copy-code buttons ───────────────────────────────── */
  function addCopyHandlers() {
    document.querySelectorAll('.copy-btn').forEach(function (btn) {
      btn.addEventListener('click', async function () {
        var code = btn.parentElement.querySelector('code');
        if (!code) return;
        try {
          await navigator.clipboard.writeText(code.innerText);
          btn.textContent = 'Copied!';
          btn.classList.add('copied');
        } catch (e) {
          btn.textContent = 'Error';
        }
        setTimeout(function () { btn.textContent = 'Copy'; btn.classList.remove('copied'); }, 1800);
      });
    });
  }

  /* ── Mermaid renderer ─────────────────────────────────── */
  async function renderMermaid() {
    if (!window.mermaid) return;
    var diagrams = document.querySelectorAll('.mermaid-wrap .mermaid');
    var id = 0;
    for (var el of diagrams) {
      try {
        var source = el.textContent || el.innerText || '';
        source = source
          .replace(/&amp;/g,'&').replace(/&lt;/g,'<').replace(/&gt;/g,'>');
        var result = await mermaid.render('mermaid-' + (++id) + '-' + Date.now(), source);
        el.innerHTML = result.svg || result;
        el.classList.add('rendered');
      } catch (e) {
        el.innerHTML = '<p class="mermaid-error">&#9888; Diagram render error: ' + (e.message||e) + '</p>';
      }
    }
  }

  /* ── Main loader ─────────────────────────────────────── */
  async function loadLesson(fileUrl) {
    var loading = document.getElementById('loadingState');
    var content = document.getElementById('markdownContent');

    try {
      var response = await fetch(fileUrl);
      if (!response.ok) throw new Error('HTTP ' + response.status + ' — file not found');
      var markdown = await response.text();

      /* Render */
      var html = window.marked ? marked.parse(markdown) : '<pre>' + escHtml(markdown) + '</pre>';

      /* Inject into temp div for DOM manipulation */
      var temp = document.createElement('div');
      temp.innerHTML = html;

      /* Set IDs on headings */
      var usedIds = {};
      temp.querySelectorAll('h1,h2,h3,h4').forEach(function (h, i) {
        var base = slugify(h.textContent);
        var uid  = usedIds[base] ? (base + '-' + (++usedIds[base])) : base;
        usedIds[base] = (usedIds[base] || 0) + 1;
        h.id = uid;
      });

      /* Extract page title */
      var h1 = temp.querySelector('h1');
      var title = h1 ? h1.textContent.trim() : fileUrl.split('/').pop().replace('.md','');
      document.title = title + ' | ASP.NET Core .NET 10 Docs';
      var breadcrumb = document.getElementById('headerBreadcrumb');
      if (breadcrumb) breadcrumb.textContent = title;

      content.innerHTML = temp.innerHTML;

      /* Show content */
      if (loading) loading.style.display = 'none';
      content.style.display = 'block';

      buildTOC();
      buildSectionNav(fileUrl);
      buildPrevNext(fileUrl);
      addCopyHandlers();
      await renderMermaid();

    } catch (err) {
      if (loading) loading.innerHTML = (
        '<div class="load-error">' +
          '<h2>&#128548; Could not load lesson</h2>' +
          '<p>' + escHtml(err.message) + '</p>' +
          '<p style="font-size:.85rem;color:var(--muted)">File: ' + escHtml(fileUrl) + '</p>' +
          '<a href="lessons.html" class="sidebar-back" style="display:inline-flex;margin-top:1rem">' +
            '&#8592; Back to lessons</a>' +
        '</div>'
      );
    }
  }

  /* ── TOC toggle (mobile) ─────────────────────────────── */
  var tocToggle  = document.getElementById('tocToggle');
  var sidebar    = document.getElementById('readerSidebar');
  var overlay    = document.getElementById('sidebarOverlay');
  tocToggle?.addEventListener('click', function () {
    sidebar?.classList.toggle('open');
    if (overlay) overlay.style.display = sidebar?.classList.contains('open') ? 'block' : 'none';
  });

  /* ── Back-to-top ─────────────────────────────────────── */
  var topBtn = document.getElementById('topBtn');
  topBtn?.addEventListener('click', function () { window.scrollTo({ top: 0, behavior: 'smooth' }); });
  window.addEventListener('scroll', function () {
    topBtn?.classList.toggle('show', window.scrollY > 380);
  });

  /* ── Close sidebar when a TOC link is clicked (mobile) ── */
  document.addEventListener('click', function (e) {
    if (e.target.closest('.toc-item') || e.target.closest('.section-nav-item')) {
      if (window.innerWidth <= 900) {
        sidebar?.classList.remove('open');
        if (overlay) overlay.style.display = 'none';
      }
    }
  });

  /* ── Boot ────────────────────────────────────────────── */
  if (rawFile) {
    loadLesson(resolveDocUrl(decodeURIComponent(rawFile)));
  } else {
    var ls = document.getElementById('loadingState');
    if (ls) ls.innerHTML = '<p>No lesson file specified. <a href="lessons.html">&#8592; Back to lessons</a></p>';
  }

})();
