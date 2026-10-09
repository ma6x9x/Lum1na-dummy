const puppeteer = require('puppeteer-core');
const path = require('path');
const url = 'file://' + path.resolve(__dirname, 'index.html');
const only = process.argv[2];
(async () => {
  const browser = await puppeteer.launch({ executablePath: '/usr/bin/google-chrome', headless: 'new',
    args: ['--no-sandbox','--disable-setuid-sandbox','--force-color-profile=srgb','--hide-scrollbars'] });
  const page = await browser.newPage();
  page.on('pageerror', e => console.error('PAGE ERROR', e.message));
  await page.setViewport({width:390,height:844,deviceScaleFactor:3});
  await page.goto(url, {waitUntil:'load'});
  await page.waitForFunction('window.__ready===true');
  await page.evaluate(()=>{ window.__capture=true; });
  async function shot(name, mode, scene, sheet){
    if(only && only!==name) return;
    await page.evaluate((m,s,sh)=>{ setMode(m); setScene(s); closeSettings(); closeConsole();
      if(sh==='settings') openSettings(); if(sh==='console') openConsole();
      if(!SCENE.st.T) SCENE.st.T=2600; renderScene(); }, mode, scene, sheet);
    await new Promise(r=>setTimeout(r,250));
    await page.screenshot({path:`renders/${name}.png`});
    console.log('shot', name);
  }
  await shot('dark-idle','dark','idle');
  await shot('dark-midrun','dark','midrun');
  await shot('dark-success','dark','success');
  await shot('light-idle','light','idle');
  await shot('settings-sheet','dark','idle','settings');
  await shot('crt-console','dark','console','console');
  await shot('crt-success','dark','success','console');
  await browser.close();
  console.log('DONE');
})();
