(() => {
  const resolveTheme = () => {
    const mode = document.documentElement.getAttribute('data-mode');
    if (mode === 'dark') return 'dark';
    if (mode === 'light') return 'default';
    const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
    return prefersDark ? 'dark' : 'default';
  };

  const hydrateMermaidBlocks = () => {
    const codeBlocks = document.querySelectorAll('div.language-mermaid, pre > code.language-mermaid');

    codeBlocks.forEach((block) => {
      if (block.dataset.mermaidHydrated === 'true') return;

      const code = block.matches('code')
        ? block
        : block.querySelector('code.language-mermaid') || block.querySelector('code');
      const diagram = document.createElement('div');
      diagram.className = 'mermaid';
      diagram.textContent = (code?.textContent || block.textContent || '').trim();
      diagram.dataset.mermaidHydrated = 'true';

      const wrapper = block.matches('div.language-mermaid') ? block : block.closest('div.language-mermaid');
      if (wrapper) {
        wrapper.replaceWith(diagram);
        return;
      }

      const pre = block.closest('pre');
      if (pre) {
        pre.replaceWith(diagram);
        return;
      }

      block.replaceWith(diagram);
    });
  };

  const render = () => {
    if (!window.mermaid) return;
    hydrateMermaidBlocks();
    window.mermaid.initialize({
      startOnLoad: false,
      theme: resolveTheme(),
      securityLevel: 'loose',
    });
    window.mermaid.run({ querySelector: '.mermaid' });
  };

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', render, { once: true });
  } else {
    render();
  }
})();
