(() => {
  const MERMAID_STARTERS = [
    'graph',
    'flowchart',
    'sequenceDiagram',
    'stateDiagram',
    'classDiagram',
    'erDiagram',
    'journey',
    'gantt',
    'pie',
    'requirementDiagram',
    'gitGraph',
    'mindmap',
    'timeline',
    'sankey-beta',
    'quadrantChart',
    'xychart-beta',
  ];

  const resolveTheme = () => {
    const mode = document.documentElement.getAttribute('data-mode');
    if (mode === 'dark') return 'dark';
    if (mode === 'light') return 'default';
    const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
    return prefersDark ? 'dark' : 'default';
  };

  const isMermaidSource = (text) => {
    const firstLine = (text || '').trim().split('\n').find((line) => line.trim().length > 0)?.trim() || '';
    return MERMAID_STARTERS.some((starter) =>
      firstLine === starter ||
      firstLine.startsWith(`${starter} `) ||
      firstLine.startsWith(`${starter}-`) ||
      firstLine.startsWith(`${starter}\t`) ||
      firstLine.startsWith(`${starter}\r`) ||
      firstLine.startsWith(`${starter}:{`)
    );
  };

  const extractCodeText = (block) => {
    const candidate = block.querySelector('td.rouge-code pre, pre code, code');
    return (candidate?.textContent || block.textContent || '').trim();
  };

  const hydrateMermaidBlocks = () => {
    const blocks = document.querySelectorAll('div.language-plaintext.highlighter-rouge, div.language-mermaid.highlighter-rouge, pre > code.language-mermaid');

    blocks.forEach((block) => {
      if (block.dataset.mermaidHydrated === 'true') return;

      const codeText = extractCodeText(block);
      if (!isMermaidSource(codeText)) return;

      const diagram = document.createElement('pre');
      diagram.className = 'mermaid';
      diagram.textContent = codeText;
      diagram.dataset.mermaidHydrated = 'true';

      const outer = block.closest('div.highlighter-rouge') || block.closest('div.language-plaintext') || block.closest('div.language-mermaid') || block.closest('pre') || block;
      outer.replaceWith(diagram);
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
    window.mermaid.run({ querySelector: 'pre.mermaid, div.mermaid' });
  };

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', render, { once: true });
  } else {
    render();
  }
})();
