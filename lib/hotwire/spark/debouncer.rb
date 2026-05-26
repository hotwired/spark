class Hotwire::Spark::Debouncer
  def initialize
    @mutex = Mutex.new
    @pending = {}
    @flush_at = nil
    @worker = nil
  end

  def enqueue(key, &block)
    @mutex.synchronize do
      @pending[key] = block
      @flush_at = monotonic_now + Hotwire::Spark.debounce_window
      return if @worker&.alive?
      @worker = Thread.new { run }
    end
  end

  private
    def run
      loop do
        remaining = @mutex.synchronize { @flush_at - monotonic_now }
        if remaining > 0
          sleep remaining
          next
        end

        to_run = @mutex.synchronize { @pending.values.tap { @pending.clear } }
        to_run.each do |block|
          begin
            block.call
          rescue => error
            Rails.logger&.error("Hotwire::Spark debouncer block raised: #{error.class}: #{error.message}")
          end
        end

        @mutex.synchronize do
          if @pending.empty?
            @worker = nil
            return
          end
        end
      end
    end

    def monotonic_now
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
end
