# Hotwire Spark

**Hotwire Spark** is a live-reloading system for Hotwire applications. It enhances your development feedback loop by detecting source code changes and updating the page *smoothly* without requiring a manual reload.

## Installation

Add the gem to the group `development`:

```ruby
group :development do
  gem "hotwire-spark"
end
```

And then execute:

```bash
$ bundle
```

That's it!

## How it works

The system will listen for three kinds of changes and will take action depending on each:

* HTML contents
* CSS
* Stimulus controllers

Depending on your setup, the default behavior will be different.

### Importmaps

Importmaps allows for the smoother updates because it supports hot-reloading for Stimulus controllers:

* **HTML change:** it fetches the new document body and updates the current body with morphing, then it reloads the Stimulus controllers in the page. It uses [`idiomorph`](https://github.com/bigskysoftware/idiomorph) under the hood.
* **CSS change:** it fetches and reloads the stylesheet that changed.
* **Stimulus controller change:** it fetches the Stimulus controller that changed and reloads all the controllers in the page.

### JavaScript Bundling

* **HTML change:** it reloads the page with a Turbo visit.
* **CSS change:** it fetches and reloads the stylesheet that changed.
* **Stimulus controller change:** it reloads the page with a Turbo visit.

## Configuration

You can set configuration options on your `development.rb`. For example:

```ruby
config.hotwire.spark.html_paths += %w[ lib ]
```

### General

| Name                  | Description                                                                                                                                                                                                                                                                                                       |
|-----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `enabled`             | Enable or disable live reloading. By default, it's only enabled in `development`.                                                                                                                                                                                                                                 |
| `logging`             | Show logs in the browser console when reloading happens. It's false by default.                                                                                                                                                                                                                                   |
| `html_reload_method`  | How to perform reloads when HTML content changes: `:morph` or `:replace`. By default, it is `:morph` and it will morph the `<body>` of the page and reload all the stimulus controllers. Set to `:replace` to reload the page with a regular Turbo navigation that will replace the `<body>` and keep the scroll. |

### Monitored paths

| Name                  | Description                                                                                                                  |
|-----------------------|------------------------------------------------------------------------------------------------------------------------------|
| `html_paths`          | Paths where file changes trigger a content refresh. By default: `app/components`, `app/controllers`, `app/helpers`, `app/models`, `app/views`. |
| `html_extensions`     | The extensions to monitor for HTML content changes. By default: `rb`, `erb`.                                                 |                                                                                                                                                                                                                                                   |
| `css_paths`           | Paths where file changes trigger a CSS refresh. By default: `app/assets/stylesheets` or `app/assets/builds` if exists.       |
| `css_extensions`      | The extensions to monitor for CSS changes. By default: `css`.                                                                |                                                                                                                                                                                                                                                   |
| `stimulus_paths`      | Paths where file changes trigger a Stimulus controller refresh. By default: `app/javascript/controllers`.                    |
| `stimulus_extensions` | The extensions to monitor for Stimulus changes. By default: `js`.                                                            |                                                                                                                                                                                                                                                   |

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
