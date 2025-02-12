import { log } from "../logger.js"

export class ReplaceHtmlReloader {
  static async reload() {
    return new ReplaceHtmlReloader().reload()
  }

  async reload() {
    if (!window.Turbo) {
      console.log(`[hotwire-spark] Tried to replace the page with Turbo, but Turbo is not available on window.Turbo`);
      return;
    }
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
    return new Promise(resolve => {
      document.addEventListener("turbo:load", () => resolve(document), { once: true })
      window.Turbo.visit(window.location)
    })
  }
}
