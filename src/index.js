import { Elm } from './BSCards.elm'

const app = Elm.BSCards.init({ node: document.getElementById('app') })

app.ports.sendXml.subscribe(function ([xml, xsl]) {
    const xmlDom = new DOMParser().parseFromString(xml, 'application/xml')
    const xslDom = new DOMParser().parseFromString(xsl, 'application/xml')

    const processor = new XSLTProcessor()
    processor.importStylesheet(xslDom)
})

app.ports.sendPrint.subscribe(() => {
    window.print()
})
