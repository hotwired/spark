require "application_system_test_case"

class HtmlReloadTest < ApplicationSystemTestCase
  test "error page is displayed" do
    visit root_path
    assert_no_text "ZeroDivisionError"

    edit_file "app/views/home/show.html.erb", replace: "_REPLACE_", with: "<%= 1 / 0 %>"

    assert_text "ZeroDivisionError"
  end
end
