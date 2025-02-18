import config from "./config"

export const LOG_TAG = "[hotwire_spark]";

export function log(...args) {
  if (config.loggingEnabled) {
    console.log(LOG_TAG, ...args)
  }
}

