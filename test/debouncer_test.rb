require "test_helper"
require "concurrent/array"

class Hotwire::Spark::DebouncerTest < ActiveSupport::TestCase
  setup do
    @debouncer = Hotwire::Spark::Debouncer.new
    @original_window = Hotwire::Spark.debounce_window
    Hotwire::Spark.debounce_window = 0.05
  end

  teardown do
    Hotwire::Spark.debounce_window = @original_window
  end

  test "coalesces calls sharing a key within the quiet window" do
    calls = Concurrent::Array.new

    10.times { @debouncer.enqueue(:same) { calls << :ran } }

    wait_for_flush
    assert_equal 1, calls.size
  end

  test "keeps the latest block for a key" do
    captured = Concurrent::Array.new

    @debouncer.enqueue(:k) { captured << :first }
    @debouncer.enqueue(:k) { captured << :second }

    wait_for_flush
    assert_equal [ :second ], captured.to_a
  end

  test "flushes one entry per distinct key" do
    calls = Concurrent::Array.new

    @debouncer.enqueue(:a) { calls << :a }
    @debouncer.enqueue(:b) { calls << :b }
    @debouncer.enqueue(:a) { calls << :a }

    wait_for_flush
    assert_equal [ :a, :b ].sort, calls.to_a.sort
  end

  test "handles a second burst after the first flush completes" do
    calls = Concurrent::Array.new

    @debouncer.enqueue(:k) { calls << 1 }
    wait_for_flush
    @debouncer.enqueue(:k) { calls << 2 }
    wait_for_flush

    assert_equal [ 1, 2 ], calls.to_a
  end

  private
    def wait_for_flush
      sleep Hotwire::Spark.debounce_window + 0.1
    end
end
