import { createConsumer } from "@rails/actioncable"
import config from "../config"

export default createConsumer(config.cableServerPath)
