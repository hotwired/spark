require "application_system_test_case"

class StimulusReloadTest < ApplicationSystemTestCase
  setup do
    visit root_path
  end

  test "reload Stimulus controller changes" do
    assert_no_text "This was replaced!"

    edit_file "app/javascript/controllers/dummy_controller.js", replace: "_REPLACE_", with: "This was replaced!"

    assert_text "This was replaced!"
  end

  test "load new Stimulus controllers" do
    assert_no_text "This was replaced!"

    edit_file "app/views/home/show.html.erb", replace: "_REPLACE_CONTROLLER_", with: "other-dummy"
    sleep 2 # Broadcasting many jobs in a row sometimes makes the test fail

    add_file "app/javascript/controllers/other_dummy_controller.js", <<~JS
      import { Controller } from "@hotwired/stimulus"

      export default class extends Controller {
        connect() {
          this.element.querySelector("p").textContent = "This was replaced!"
        }
      }
    JS

    assert_text "This was replaced!"
  end

  test "load namespaced Stimulus controllers" do
    assert_no_text "This was replaced!"

    edit_file "app/views/home/show.html.erb", replace: "_REPLACE_CONTROLLER_", with: "namespaced--dummy"
    sleep 2

    add_file "app/javascript/controllers/namespaced/dummy_controller.js", <<~JS
      import { Controller } from "@hotwired/stimulus"

      export default class extends Controller {
        connect() {
          this.element.querySelector("p").textContent = "This was replaced!"
        }
      }
    JS

    assert_text "This was replaced!"
  end

  test "unload removed Stimulus controllers" do
    assert_css "[data-dummy-version]"

    remove_file "app/javascript/controllers/dummy_controller.js"

    assert_no_css "[data-dummy-version]"
  end
end
