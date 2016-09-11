module CucumberWaitTurbolinksRequests
  def wait_turbolinks_requests
    Timeout.timeout(Capybara.default_max_wait_time) do
      sleep 0.1 until all_turbolinks_requests_finished?
    end
  end

  def all_turbolinks_requests_finished?
    have_selector("body.turbolinks-load")
  end
end

World(CucumberWaitTurbolinksRequests)

# Auto wait turbolinks requests between steps
AfterStep do |scenario|
  if page.evaluate_script('typeof Turbolinks') != "undefined"
    evaluate_script %(
      $(document).on("turbolinks:before-visit", function(){
        $("body").addClass("turbolinks-load")
      })

      $(document).on("turbolinks:load", function(){
        $("body").removeClass("turbolinks-load")
      })
    )

    wait_turbolinks_requests
  end
end
