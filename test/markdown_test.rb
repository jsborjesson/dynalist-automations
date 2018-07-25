require "test_helper"
require "./lib/markdown"

class MarkdownTest < Minitest::Test
  def test_date
    assert_equal "A date 2018-08-09", Markdown.render("A date !(2018-08-09)")
    assert_equal "A datetime 2018-08-09 15:30", Markdown.render("A datetime !(2018-08-09 15:30)")
  end

  def test_link
    assert_equal "A link and stuff )", Markdown.render("A [link and](https://example.com) stuff )")
  end
end
