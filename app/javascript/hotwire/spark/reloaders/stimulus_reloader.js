import { log } from "../logger.js"

export class StimulusReloader {
  static async reload(path) {
    return new StimulusReloader(path).reload()
  }

  static async reloadAll() {
    Stimulus.controllers.forEach(controller => {
      Stimulus.unload(controller.identifier)
      Stimulus.register(controller.identifier, controller.constructor)
    })

    return Promise.resolve()
  }

  constructor(changedPath) {
    this.changedPath = changedPath
    this.application = window.Stimulus
  }

  async reload() {
    log("Reload Stimulus controllers...")

    this.application.stop()

    try {
      await this.#reloadChangedController()
    }
    catch(error) {
      if (error instanceof SourceFileNotFound) {
        this.#deregisterChangedController()
      } else {
        console.error("Error reloading controller", error)
      }
    }

    this.application.start()
  }

  async #reloadChangedController() {
    const module = await this.#importControllerFromSource(this.changedPath)
    await this.#registerController(this.#changedControllerIdentifier, module)
  }

  async #importControllerFromSource(path) {
    const response = await fetch(`/spark/source_files/?path=${path}`)

    if (response.status === 404) {
      throw new SourceFileNotFound(`Source file not found: ${path}`)
    }

    const sourceCode = await response.text()

    const blob = new Blob([sourceCode], { type: "application/javascript" })
    const moduleUrl = URL.createObjectURL(blob)
    const module = await import(moduleUrl)
    URL.revokeObjectURL(moduleUrl)

    return module
  }

  get #changedControllerIdentifier() {
    this.changedControllerIdentifier = this.changedControllerIdentifier || this.#extractControllerName(this.changedPath)
    return this.changedControllerIdentifier
  }

  #extractControllerName(path) {
    const stimulusPaths = (HotwireSpark.config.stimulusPaths || "").split(' ');
    const basePath = stimulusPaths.find(base => path.startsWith(base));

    if (basePath) path = path.replace(basePath, '');

    return path
      .replace(/^\/+/, "")
      .replace("_controller", "")
      .replace(/\//g, "--")
      .replace(/_/g, "-")
      .replace(/\.js$/, "")
  }

  #deregisterChangedController() {
    this.#deregisterController(this.#changedControllerIdentifier)
  }

  #registerController(name, module) {
    log("\tReloading controller", name)

    this.application.unload(name)
    this.application.register(name, module.default)
  }

  #deregisterController(name) {
    log(`\tRemoving controller ${name}`)
    this.application.unload(name)
  }
}

class SourceFileNotFound extends Error { }
