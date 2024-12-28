require "application_system_test_case"

class ReplaceHtmlReloadTest < ApplicationSystemTestCase
  setup do
    Hotwire::Spark.html_reload_method = :replace
  end

  test "reload HTML changes" do
    visit root_path
    assert_no_text "This is pretty amazing"

    edit_file "app/views/home/show.html.erb", replace: "cool", with: "amazing"

    assert_text "This is pretty amazing"
    assert_css "[data-turbo-navigated]"
  end

  test "errors don't show the error page" do
    visit root_path
    assert_no_text "ZeroDivisionError"

    edit_file "app/views/home/show.html.erb", replace: "_REPLACE_HTML_", with: "<%= 1 / 0 %>"

    assert_css "[data-turbo-navigated]"
    assert_no_text "ZeroDivisionError"
  end
end
