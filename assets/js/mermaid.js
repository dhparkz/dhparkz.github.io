(() => {
  const resolveTheme = () => {
    const mode = document.documentElement.getAttribute('data-mode');
    if (mode === 'dark') return 'dark';
    if (mode === 'light') return 'default';
    const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
    return prefersDark ? 'dark' : 'default';
  };

  const render = () => {
    if (!window.mermaid) return;
    window.mermaid.initialize({
      startOnLoad: false,
      theme: resolveTheme(),
      securityLevel: 'loose',
    });
    window.mermaid.run({ querySelector: '.language-mermaid, .mermaid' });
  };

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', render, { once: true });
  } else {
    render();
  }
})();
