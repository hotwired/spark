import config from "./config"

export function log(...args) {
  if (config.loggingEnabled) {
    console.log(`[hotwire_spark]`, ...args)
  }
}

