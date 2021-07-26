# frozen_string_literal: true

module DocumentationService
  class MarkdownDocumentationRenderer < Redcarpet::Render::HTML
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::UrlHelper

    def link(link, _title, content)
      return super if link.match?(/^http/)

      parts = link.split("/")

      if parts.size == 1
        link_to content, management_section_path(get_md_filename(link))
      elsif parts.size == 2
        link_to content, management_chapter_path(parts[0], get_md_filename(link))
      end
    end

    def get_md_filename(link)
      link.split("/").last.sub(".md", "")
    end
  end
end
