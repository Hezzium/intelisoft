const puppeteer = require('puppeteer');
const request = require('request-promise');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage()

  // Ir a login
  // Poner rut y constraseña
  // Sacar screenshot (guarda en mismo carpeta q este archivo)
  // Esperar
  await page.goto('https://www.bci.cl/empresarios')
  await page.click('.entry-account')
  await page.waitFor(1000)
  await page.click('.btnempresarios')
  await page.waitFor(2000)
  await page.type('#rut_aux', 'aca-va-el-rut')
  await page.type('#clave', 'aca-va-la-clave')
  await page.screenshot({ path: 'antes.png' })
  await page.click('.submit')
  await page.waitFor(8000)

  // Click en el menu hasta llegar a cartola
  // Sacar screenshot (guarda en mismo carpeta q este archivo)
  await page.click('#cct')
  await page.waitFor(1000)
  await page.click('#cart')
  await page.waitFor(1000)
  await page.click('#red li:nth-child(2) > ul > li:nth-child(2) > ul > li:nth-child(2)')
  await page.waitFor(8000)
  // En este momento se podria extraer la informacion de la cartola a CSV
  await page.screenshot({ path: 'despues.png' })

  // Este es un intento de bajar la cartola a archivo excel
  // await page.click('.herramienta_excel')
  // await page.screenshot({ path: 'despues2.png' })

  browser.close()
  console.log('Rutina exitosa')
})();
