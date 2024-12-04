class HotwireSpark::Server
  WEBSOCKET_PATH = "/hotwire_spark"

  def initialize(app)
    @app = app
  end

  def call(env)
    if env["PATH_INFO"] == WEBSOCKET_PATH && (websocket = HotwireSpark::Websockets.open(env))
      websocket.rack_response
    else
      @app.call(env)
    end
  end
end
