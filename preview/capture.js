const puppeteer = require('puppeteer-core');
const path = require('path'), fs=require('fs');
const url = 'file://' + path.resolve(__dirname, 'index.html');
(async () => {
  fs.rmSync('frames',{recursive:true,force:true}); fs.mkdirSync('frames');
  const browser = await puppeteer.launch({executablePath:'/usr/bin/google-chrome',headless:'new',
    args:['--no-sandbox','--disable-setuid-sandbox','--force-color-profile=srgb','--hide-scrollbars']});
  const page = await browser.newPage();
  await page.setViewport({width:390,height:844,deviceScaleFactor:2});
  await page.goto(url,{waitUntil:'load'});
  await page.waitForFunction('window.__ready===true');
  await page.evaluate(()=>{ window.__capture=true; setMode('dark'); closeSettings(); closeConsole(); });
  const end = await page.evaluate(()=>window.timelineEnd);
  const step=1000/30; const n=Math.ceil(end/step);
  console.log('frames to capture:', n, 'timelineEnd ms:', Math.round(end));
  for(let i=0;i<n;i++){
    await page.evaluate((t)=>window.renderAtTime(t), i*step);
    await page.screenshot({path:`frames/f${String(i).padStart(5,'0')}.png`});
  }
  await browser.close();
  console.log('CAPTURED', n);
})();
