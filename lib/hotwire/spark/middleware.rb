class Hotwire::Spark::Middleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)

    @request = ActionDispatch::Request.new(env)

    if interceptable_request? && html_response?(headers)
      html = html_from(response)
      html = inject_options(html)
      html = inject_javascript(html)
      headers["Content-Length"] = html.bytesize.to_s if html
      response = [ html ]
    end

    [ status, headers, response ]
  end

  private
    def interceptable_request?
      @request.controller_instance.present?
    end

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
      script_path = view_helpers.path_to_asset("hotwire_spark.js")
      view_helpers.javascript_include_tag(script_path, defer: "", nonce: true)
    end

    def view_helpers
      @request.controller_instance.helpers
    end

    def inject_options(html)
      html.sub("</head>", "#{options}</head>")
    end

    def options
      [ logging_option, html_reload_method_option, cable_server_path_option ].compact.join("\n")
    end

    def cable_server_path_option
      view_helpers.tag.meta(name: "hotwire-spark:cable-server-path", content: Hotwire::Spark.cable_server_path)
    end

    def logging_option
      view_helpers.tag.meta(name: "hotwire-spark:logging", content: "true") if Hotwire::Spark.logging
    end

    def html_reload_method_option
      view_helpers.tag.meta(name: "hotwire-spark:html-reload-method", content: Hotwire::Spark.html_reload_method)
    end
end
