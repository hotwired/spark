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

    this.#maintainScrollPosition()
    await this.#visitCurrentPage()
  }

  #maintainScrollPosition() {
    document.addEventListener("turbo:render", () => {
      Turbo.navigator.currentVisit.scrolled = true
    }, { once: true })
  }

  #visitCurrentPage() {
    return new Promise(resolve => {
      document.addEventListener("turbo:load", () => resolve(document), { once: true })
      window.Turbo.visit(window.location)
    })
  }
}