require "listen"

class Hotwire::Spark::FileWatcher
  def initialize
    @callbacks_by_path = Hash.new { |hash, key| hash[key] = [] }
  end

  def monitor(paths, &callback)
    Array(paths).each do |path|
      @callbacks_by_path[expand_path(path)] << callback
    end
  end

  def start
    listener = Listen.to(*paths) do |modified, added, removed|
      process_changed_files modified + added + removed
    end

    listener.start
  end

  private
    def expand_path(path)
      Rails.application.root.join(path)
    end

    def paths
      only_existing_paths @callbacks_by_path.keys
    end

    def only_existing_paths(paths)
      paths.select(&:exist?)
    end

    def process_changed_files(changed_files)
      changed_files.each do |file|
        @callbacks_by_path.each do |path, callbacks|
          if file.to_s.start_with?(path.to_s)
            callbacks.each { |callback| callback.call(as_relative_path(file)) }
          end
        end
      end
    end

    def as_relative_path(path)
      Pathname.new(path).relative_path_from(Rails.application.root)
    end
end
