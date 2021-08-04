# frozen_string_literal: true

ActiveAdmin.register_page "Attributions" do
  menu false

  content do
    div class: "blank_slate_container" do
      div(class: "text-left") do
        div do
          span { "File icons made by" }
          a(href: "https://www.freepik.com", target: "_blank") { "Freepik" }
        end
      end
    end
  end
end
