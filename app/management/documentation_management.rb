# frozen_string_literal: true

ActiveAdmin.register_page "Documentation" do
  page_action :chapter, path: "/:section/:chapter", as: :chapter
  page_action :section, path: "/:section", as: :section

  content title: "Documentation" do
    div class: "blank_slate_container" do
      render_markdown(Rails.root.join("documentation/index.md"))
    end
  end

  controller do
    def chapter
      @chapter_markdown_file = chapter_markdown_file.tap do |file|
        return redirect_to management_documentation_path, notice: "Documentation not found" unless file
      end
    end

    def section
      @section_markdown_file = section_markdown_file.tap do |file|
        return redirect_to management_documentation_path, notice: "Documentation not found" unless file
      end
    end

    def chapter_markdown_file
      file = Rails.root.join("documentation/#{params[:section]}/#{params[:chapter]}.md")
      return file if File.exist?(file)
    end

    def section_markdown_file
      file = Rails.root.join("documentation/#{params[:section]}.md")
      return file if File.exist?(file)
    end

    delegate :render_markdown, to: :markdown_helper
    def markdown_helper
      @markdown_helper ||= DocumentationService::RenderMarkdown.new
    end

    helper_method :render_markdown
  end
end
