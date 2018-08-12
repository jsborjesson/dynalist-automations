require "test_helper"
require "document"

class DocumentTest < Minitest::Test
  def test_from_json
    doc = Document.from_json("doc_id", Factory.document_response)

    assert_equal "doc_id", doc.id
    assert_equal 6, doc.bullets.count
    assert doc.bullets.all? { |b| Bullet === b }
  end

  def test_with_date
    bullets = [
      Factory.bullet,
      one = Factory.bullet(note: "!(2018-08-09 15:15)"),
      two = Factory.bullet(content: "!(2018-08-09)"),
      Factory.bullet(content: "!(2018-08-10)"),
    ]
    doc = Document.new("doc_id", bullets)

    assert_equal [one, two], doc.with_date(Date.new(2018, 8, 9)).bullets
  end
end
