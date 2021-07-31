# frozen_string_literal: true

module DocumentationService
  class RenderMarkdown
    def render_markdown(file_path)
      markdown.render(SafeFile.read(file_path)).html_safe
    end

    def markdown
      @markdown ||= Redcarpet::Markdown.new(MarkdownDocumentationRenderer, fenced_code_blocks: true)
    end
  end
end
