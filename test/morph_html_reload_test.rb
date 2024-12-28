require "application_system_test_case"

class MorphHtmlReloadTest < ApplicationSystemTestCase
  setup do
    Hotwire::Spark.html_reload_method = :morph
  end

  test "reload HTML changes" do
    visit root_path
    assert_no_text "This was morphed"

    edit_file "app/views/home/show.html.erb", replace: "_REPLACE_", with: "This was morphed!"

    assert_text "This was morphed"
    assert_no_css "[data-turbo-navigated]"
  end
end
