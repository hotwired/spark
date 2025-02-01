require "hotwire/spark/version"
require "hotwire/spark/engine"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.ignore("#{__dir__}/hotwire-spark.rb")
loader.ignore("#{__dir__}/hotwire/spark/version.rb")
loader.setup

module Hotwire::Spark
  %i[ css html stimulus ].each do |type|
    mattr_accessor "#{type}_paths".to_sym, default: []
    mattr_accessor "#{type}_extensions".to_sym, default: []
  end

  mattr_accessor :logging, default: false
  mattr_accessor :html_reload_method, default: :morph
  mattr_accessor :enabled, default: Rails.env.development?
  mattr_accessor :cable_server_path, default: "/hotwire-spark"

  class << self
    def install_into(application)
      Installer.new(application).install
    end

    def enabled?
      enabled && (defined?(Rails::Server) || $PROGRAM_NAME =~ /puma/)
    end

    def cable_server
      @server ||= Hotwire::Spark::ActionCable::Server.new
    end
  end
end
