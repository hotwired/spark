import { log } from "../logger.js"

export class ReplaceHtmlReloader {
  static async reload() {
    return new ReplaceHtmlReloader().reload()
  }

  async reload() {
    await this.#reloadHtml()
  }

  async #reloadHtml() {
    log("Reload html with Turbo...")

    this.#keepScrollPosition()
    await this.#visitCurrentPage()
  }

  #keepScrollPosition() {
    document.addEventListener("turbo:before-render", () => {
      Turbo.navigator.currentVisit.scrolled = true
    }, { once: true })
  }

  #visitCurrentPage() {
    this.#hideProgressbar()
    return new Promise(resolve => {
      document.addEventListener("turbo:load", () => {
        resolve(document)
      }, { once: true })
      this.#stopVisitOnError()
      window.Turbo.visit(window.location)
    })
  }

  #hideProgressbar() {
    const style = document.createElement('style');
    style.type = 'text/css';
    style.textContent = '.turbo-progress-bar { display: none; }';
    document.head.appendChild(style);
    return style
  }

  #stopVisitOnError() {
    document.addEventListener("turbo:before-fetch-response", (event) => {
      const responseStatus = event.detail.fetchResponse.response.status
      if(responseStatus >= 400) {
        event.preventDefault()
      }
    }, { once: true })
  }
}
