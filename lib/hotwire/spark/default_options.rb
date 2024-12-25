class Hotwire::Spark::DefaultOptions
  def initialize
    @config = base_options

    build
  end

  def to_h
    @config
  end

  private
    def base_options
      {
        enabled: Rails.env.development?,
        css_paths: File.directory?("app/assets/builds") ? %w[ app/assets/builds ] : %w[ app/assets/stylesheets ],
        css_extensions: %w[ css ],
        html_paths: %w[ app/components app/controllers app/helpers app/models app/views ],
        html_extensions: %w[ rb erb ],
        stimulus_paths: %w[ app/javascript/controllers ],
        stimulus_extensions: %w[ js ],
        html_reload_method: :morph
      }
    end

    def build
      configure_jsbundling if defined?(Jsbundling)
    end

    def configure_jsbundling
      @config[:stimulus_paths] = []
      @config[:html_paths] << "app/assets/builds"
      @config[:html_extensions] << "js"
      @config[:html_reload_method] = :replace
    end
end
