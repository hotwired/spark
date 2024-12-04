require "faye/websocket"

class HotwireSpark::Websockets
  class << self
    def open(env)
      if Faye::WebSocket.websocket?(env)
        instance.open(env)
      end
    end

    def instance
      @@instance ||= new
    end

    delegate :broadcast, to: :instance
  end

  def open(env)
    Faye::WebSocket.new(env, nil).tap do |web_socket|
      web_socket.on :open do |_event|
        Rails.logger.info "WebSocket connection opened (total: #{connections.size})"
        connections << web_socket
      end

      web_socket.on :message do |event|
        broadcast("Server received: #{event.data}")
        Rails.logger.info "Received message: #{event.data}"
      end

      web_socket.on :close do |_event|
        Rails.logger.info "WebSocket connection closed (total: #{connections.size})"
        connections.delete(web_socket)
      end
    end
  end

  def broadcast(message)
    connections.each do |connection|
      connection.send(message)
    end
  end

  def connections
    @connections ||= Concurrent::Array.new
  end
end
