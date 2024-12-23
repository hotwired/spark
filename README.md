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

* **HTML change:** it fetches the new document body and updates the current body with morphing. It uses [`idiomorph`](https://github.com/bigskysoftware/idiomorph) under the hood.
* **CSS change:** it fetches and reloads the stylesheet that changed.
* **Stimulus controller change:** it fetches the Stimulus controller that changed and reloads all the controllers in the page.

> [!NOTE]  
> Hotwire Spark currently does not support `jsbundling`, only import maps.

## Configuration

You can set configuration options on your `development.rb`. For example:

```ruby
config.hotwire.spark.html_paths += %w[ lib ]
```

| Name                 | Description                                                                                                                                                     |
|----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `html_paths`         | Paths where file changes trigger a content refresh. By default: `app/controllers`, `app/helpers`, `app/models`, `app/views`.                                    |
| `css_paths`          | Paths where file changes trigger a CSS refresh. By default: `app/assets/stylesheets` or `app/assets/builds` if exists.                                          |
| `stimulus_paths`     | Paths where file changes trigger a Stimulus controller refresh. By default: `app/javascript/controllers`.                                                       |
| `enabled`            | Enable or disable live reloading. By default, it's only enabled in `development`.                                                                               |
| `logging`            | Show logs in the browser console when reloading happens. It's false by default.                                                                                 |
| `html_reload_method` | Reload html by morphing (`"morph"`) or with a Turbo page reload (`"replace"`). By default `"morph"`. Use `"replace"` if your app is incompatible with morphing. |

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
