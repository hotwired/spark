class Hotwire::Spark::Installer
  def initialize(application)
    @application = application
  end

  def install
    configure_cable_server
    configure_middleware
    monitor_paths
  end

  private
    attr_reader :application
    delegate :middleware, to: :application

    def configure_cable_server
      application.routes.prepend do
        mount Hotwire::Spark.cable_server => Hotwire::Spark.cable_server_path, internal: true, anchor: true
      end
    end

    def configure_middleware
      middleware.use Hotwire::Spark::Middleware
    end

    def monitor_paths
      register_monitored_paths
      file_watcher.start
    end

    def register_monitored_paths
      monitor :css_paths, action: :reload_css, extensions: Hotwire::Spark.css_extensions
      monitor :html_paths, action: :reload_html, extensions: Hotwire::Spark.html_extensions
      monitor :stimulus_paths, action: :reload_stimulus, extensions: Hotwire::Spark.stimulus_extensions
    end

    def monitor(paths_name, action:, extensions:)
      monitored_paths = Hotwire::Spark.public_send(paths_name)
      file_watcher.monitor monitored_paths do |changed_path|
        broadcast_change(monitored_paths, extensions, changed_path, action)
      end
    end

    def broadcast_change(monitored_paths, extensions, changed_path, action)
      Hotwire::Spark::Change.new(monitored_paths, extensions, changed_path, action).broadcast
    end

    def file_watcher
      @file_watches ||= Hotwire::Spark::FileWatcher.new
    end
end
