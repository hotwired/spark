import { ReloadingMonitor } from "./reloading_monitor.js"

export const HotwireSpark = {
  config: {
    loggingEnabled: true,
  }
}

ReloadingMonitor.start()
