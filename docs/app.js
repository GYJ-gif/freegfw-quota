'use strict';
const $ = (selector) => document.querySelector(selector);
const $$ = (selector) => [...document.querySelectorAll(selector)];
const toast = (text) => {
  $('#toast').textContent = text;
  $('#toast').classList.add('visible');
  clearTimeout(toast.timer);
  toast.timer = setTimeout(() => $('#toast').classList.remove('visible'), 2600);
};

// No analytics, server requests, or credentials: all interactions stay in the page.
const setTheme = (theme) => {
  document.documentElement.dataset.theme = theme;
  $('#theme-toggle').setAttribute('aria-label', theme === 'dark' ? '切换为浅色模式' : '切换为深色模式');
};
try { setTheme(localStorage.getItem('quota-docs-theme-v2') === 'light' ? 'light' : 'dark'); } catch { setTheme('dark'); }
$('#theme-toggle').addEventListener('click', () => {
  const theme = document.documentElement.dataset.theme === 'dark' ? 'light' : 'dark';
  setTheme(theme);
  try { localStorage.setItem('quota-docs-theme-v2', theme); } catch { /* Private browser storage may be unavailable. */ }
});

const installUrl = 'https://raw.githubusercontent.com/GYJ-gif/freegfw-quota/main/install-quota.sh';
$('#panel-port').addEventListener('input', () => {
  const raw = $('#panel-port').value;
  const port = Number(raw);
  const valid = /^\d+$/.test(raw) && port >= 1 && port <= 65535;
  $('#port-error').hidden = valid;
  $('#panel-port').setAttribute('aria-invalid', String(!valid));
  $('[data-copy="install-command"]').disabled = !valid;
  if (!valid) return;
  const run = port === 8080 ? 'sudo bash install-quota.sh' : `sudo env FREEGFW_PANEL_PORT=${port} bash install-quota.sh`;
  $('#install-command').textContent = `curl -fSL ${installUrl} -o install-quota.sh && ${run}`;
  $('#panel-address').textContent = `http://服务器IP:${port}`;
});

const tabs = $$('[role="tab"]');
const selectTab = (tab) => {
  tabs.forEach((item) => { item.setAttribute('aria-selected', String(item === tab)); item.tabIndex = item === tab ? 0 : -1; });
  $('#install-content').setAttribute('aria-labelledby', tab.id);
  $('#install-description').textContent = tab.dataset.mode === 'fresh'
    ? '空白服务器直接安装配额版；没有 Docker 时，自动使用 Docker 官方脚本安装。'
    : '使用同一条命令升级。原容器必须正常运行、使用 host 网络并持久化 /data；面板需已设置账号。自定义端口请填写原面板端口。';
};
tabs.forEach((tab, index) => {
  tab.addEventListener('click', () => selectTab(tab));
  tab.addEventListener('keydown', (event) => {
    if (['ArrowLeft', 'ArrowRight', 'Home', 'End'].includes(event.key)) {
      event.preventDefault();
      const target = event.key === 'Home' ? tabs[0] : event.key === 'End' ? tabs[tabs.length - 1] : tabs[(index + 1) % tabs.length];
      selectTab(target); target.focus();
    }
  });
});

$$('[data-copy]').forEach((button) => button.addEventListener('click', async () => {
  const target = document.getElementById(button.dataset.copy);
  try {
    if (!navigator.clipboard) throw new Error('Clipboard unavailable');
    await navigator.clipboard.writeText(target.textContent);
    toast('命令已复制');
  } catch {
    const selection = window.getSelection();
    const range = document.createRange(); range.selectNodeContents(target);
    selection.removeAllRanges(); selection.addRange(range);
    toast('已选中命令，请按 Ctrl+C 或长按复制');
  }
}));

const menu = $('#sidebar');
const closeMenu = () => { menu.classList.remove('open'); $('#menu-toggle').setAttribute('aria-expanded', 'false'); };
$('#menu-toggle').addEventListener('click', () => {
  const open = menu.classList.toggle('open'); $('#menu-toggle').setAttribute('aria-expanded', String(open));
});
$$('#sidebar a').forEach((link) => link.addEventListener('click', closeMenu));
document.addEventListener('click', (event) => {
  if (!menu.contains(event.target) && !$('#menu-toggle').contains(event.target)) closeMenu();
});

const sections = $$('.doc-section');
const navLinks = $$('#sidebar nav a');
const order = ['overview','install','setup','protocols','clients','quota','warp','upgrade','troubleshooting','faq'];
sections.forEach(section => section.querySelectorAll('h2,h3').forEach((heading,i) => { heading.id = section.id+'-heading-'+i; }));
const route = () => {
  const id = location.hash.slice(1) || 'overview';
  const active = document.getElementById(id);
  const section = active?.closest('.doc-section') || document.getElementById('overview');
  sections.forEach(item => { item.hidden = item !== section; });
  navLinks.forEach(link => {
    const selected = link.hash === '#' + section.id;
    link.classList.toggle('active', selected);
    if (selected) link.setAttribute('aria-current','page'); else link.removeAttribute('aria-current');
  });
  const index = order.indexOf(section.id);
  const pager = $('#chapter-pagination'); pager.replaceChildren();
  for (const [offset,label] of [[-1,'← 上一步'],[1,'下一步 →']]) {
    const next = document.getElementById(order[index+offset]);
    if (!next) { pager.append(document.createElement('span')); continue; }
    const link = document.createElement('a'); link.href='#'+next.id;
    const small=document.createElement('span'); small.textContent=label;
    const title=document.createElement('strong'); title.textContent=next.dataset.title;
    link.append(small,title); pager.append(link);
  }
  const toc=$('.on-this-page'); toc.replaceChildren();
  const caption=document.createElement('span');caption.textContent='本章内容';toc.append(caption);
  section.querySelectorAll('h2,h3').forEach((heading,i)=>{
    if(!heading.id) heading.id=section.id+'-heading-'+i;
    const link=document.createElement('a');link.href='#'+heading.id;link.textContent=heading.textContent;toc.append(link);
  });
  document.title=section.dataset.title+' · FreeGFW Quota';
  closeMenu();
  if(active && active !== section) active.scrollIntoView(); else window.scrollTo(0,0);
};
window.addEventListener('hashchange',route); route();

const dialog = $('#search-dialog');
const searchIndex = sections.map((section) => ({ id: section.id, title: section.dataset.title, text: section.textContent.replace(/\s+/g, ' ').trim() }));
const search = () => {
  const query = $('#search-input').value.trim().toLocaleLowerCase();
  const hits = searchIndex.filter((section) => !query || section.text.toLocaleLowerCase().includes(query));
  const list = $('#search-results'); list.replaceChildren();
  if (!hits.length) { const empty = document.createElement('p'); empty.textContent = '没有找到相关内容，试试“端口”“配额”或“回退”。'; list.append(empty); }
  hits.forEach((hit) => {
    const link = document.createElement('a'); link.href = '#' + hit.id;
    const title = document.createElement('b'); title.textContent = hit.title;
    const excerpt = document.createElement('span');
    const index = query ? hit.text.toLocaleLowerCase().indexOf(query) : 0;
    const start = Math.max(0, index - 20);
    excerpt.textContent = (start ? '…' : '') + hit.text.slice(start, start + 90) + '…';
    link.append(title, excerpt); link.addEventListener('click', () => dialog.close()); list.append(link);
  });
};
$('#search-open').addEventListener('click', () => { dialog.showModal(); search(); $('#search-input').focus(); });
$('#search-close').addEventListener('click', () => dialog.close());
$('#search-input').addEventListener('input', search);
dialog.addEventListener('click', (event) => { if (event.target === dialog) { const rect = dialog.getBoundingClientRect(); if (event.clientX < rect.left || event.clientX > rect.right || event.clientY < rect.top || event.clientY > rect.bottom) dialog.close(); } });
document.addEventListener('keydown', (event) => {
  if (event.key === 'Escape') closeMenu();
  if (event.key === '/' && !['INPUT', 'TEXTAREA'].includes(document.activeElement.tagName) && !dialog.open) {
    event.preventDefault(); $('#search-open').click();
  }
});
