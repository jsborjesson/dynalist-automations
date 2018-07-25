# Cleans up Dynalist Flavored Markdown
class Markdown
  DATE_MARKER = /!\((.+?)\)/
  LINK_MARKER = /\[(.*?)\]\(.*?\)/

  def self.render(markup)
    markup
      .gsub(DATE_MARKER, "\\1")
      .gsub(LINK_MARKER, "\\1")
  end
end
