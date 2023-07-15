import { Elm } from './BSCards.elm'

const app = Elm.BSCards.init({ node: document.getElementById('app') })

app.ports.sendXml.subscribe(function ([xml, xsl]) {
    const xmlDom = new DOMParser().parseFromString(xml, 'application/xml')
    const xslDom = new DOMParser().parseFromString(xsl, 'application/xml')

    const processor = new XSLTProcessor()
    processor.importStylesheet(xslDom)
    try {
        const fragment = processor.transformToFragment(xmlDom, document)
        const wrap = document.createElement('div')
        wrap.appendChild(fragment)
        app.ports.receiveFragment.send(wrap.innerHTML)
        // app.ports.receiveFragment.send({success: true, data: wrap.innerHTML})
    } catch (err) {
        app.ports.receiveFragment.send(err.message)
        // app.ports.receiveFragment.send({success: false, data: err})
    }
})

app.ports.sendPrint.subscribe(() => {
    window.print()
})
