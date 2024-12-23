import { log } from "../logger.js"

export class ReplaceHtmlReloader {
  static async reload() {
    return new ReplaceHtmlReloader().reload()
  }

  async reload() {
    await this.#reloadWithTurbo()
  }

  #reloadWithTurbo() {
    log("Reload html with Turbo...")

    this.#maintainScrollPosition()
  
    return new Promise(resolve => {
      document.addEventListener("turbo:load", () => resolve(document), { once: true })
      window.Turbo.visit(window.location)
    })
  }

  #maintainScrollPosition() {
    document.addEventListener("turbo:render", () => {
      Turbo.navigator.currentVisit.scrolled = true
    }, { once: true })
  }
}
