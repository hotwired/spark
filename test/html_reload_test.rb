require "application_system_test_case"

class HtmlReloadTest < ApplicationSystemTestCase
  test "reload HTML changes" do
    visit root_path
    assert_no_text "This was replaced"

    edit_file "app/views/home/show.html.erb", replace: "_REPLACE_HTML_", with: "This was replaced!"

    assert_text "This was replaced"
  end
end
