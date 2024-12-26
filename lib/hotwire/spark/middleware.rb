class Hotwire::Spark::Middleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)

    if html_response?(headers)
      @request = ActionDispatch::Request.new(env)
      html = html_from(response)
      html = inject_javascript(html)
      html = inject_options(html)
      headers["Content-Length"] = html.bytesize.to_s if html
      response = [ html ]
    end

    [ status, headers, response ]
  end

  private
    def html_response?(headers)
      headers["Content-Type"]&.include?("text/html")
    end

    def html_from(response)
      response_body = []
      response.each { |part| response_body << part }
      response_body.join
    end

    def inject_javascript(html)
      html.sub("</head>", "#{script_tag}</head>")
    end

    def script_tag
      script_path = view_helpers.asset_path("hotwire_spark.js")
      view_helpers.javascript_include_tag(script_path)
    end

    def view_helpers
      @request.controller_instance.helpers
    end

    def inject_options(html)
      html.sub("</head>", "#{options}</head>")
    end

    def options
      [ logging_option, html_reload_method_option, stimulus_paths ].compact.join("\n")
    end

    def logging_option
      view_helpers.tag.meta(name: "hotwire-spark:logging", content: "true") if Hotwire::Spark.logging
    end

    def html_reload_method_option
      view_helpers.tag.meta(name: "hotwire-spark:html-reload-method", content: Hotwire::Spark.html_reload_method)
    end

    def stimulus_paths
      view_helpers.tag.meta(name: "hotwire-spark:stimulus-paths", content: Hotwire::Spark.stimulus_paths)
    end
end
