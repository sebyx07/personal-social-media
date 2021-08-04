# frozen_string_literal: true

ActiveAdmin.register_page "About" do
  content do
    div class: "blank_slate_container" do
      div(class: "text-left") do
        link_to "Attributions", management_attributions_path
      end
    end
  end
end
