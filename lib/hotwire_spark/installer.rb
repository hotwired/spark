require "turbo-rails"

class HotwireSpark::Installer
  attr_reader :file_watcher

  def initialize(application)
    @application = application
  end

  def install
    configure_middleware
    monitor_paths
  end

  private
    attr_reader :application
    delegate :middleware, to: :application

    def configure_middleware
      middleware.unshift HotwireSpark::Server
      middleware.use HotwireSpark::Middleware
    end

    def monitor_paths
      monitor :css_paths, action: :reload_css
      monitor :html_paths, action: :reload_html
      monitor :stimulus_paths, action: :reload_stimulus

      file_watcher.start
    end

    def monitor(paths_name, action:)
      file_watcher.monitor HotwireSpark.public_send(paths_name) do |file_path|
        HotwireSpark::Websockets.broadcast(change_message_for(action, file_path))
      end
    end

    def change_message_for(action, file_path)
      { action: action, path: file_path }.to_json
    end

    def file_watcher
      @file_watches ||= HotwireSpark::FileWatcher.new
    end
end
