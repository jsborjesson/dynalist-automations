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

  def test_unchecked
    bullets = [
      one = Factory.bullet(checked: false),
      two = Factory.bullet(checked: true),
      three = Factory.bullet(checked: false),
    ]
    doc = Document.new("doc_id", bullets)

    assert_equal [one, three], doc.unchecked.bullets
  end

  def test_with_tag
    bullets = [
      Factory.bullet,
      one = Factory.bullet(note: "Stuff with a #tag"),
      two = Factory.bullet(content: "Other @tag stuff"),
      Factory.bullet(content: "!(2018-08-10)"),
    ]
    doc = Document.new("doc_id", bullets)

    assert_equal [one, two], doc.with_tag("tag").bullets
  end

  def test_bullet_id
    doc = Factory.document

    assert_kind_of Bullet, doc.bullet("root")
    assert_equal "root", doc.bullet("root").id
  end

  def test_children
    doc = Factory.document

    root = doc.bullet("root")
    children = doc.children(root)

    assert_equal 2, children.count
    assert_kind_of Bullet, children.first
  end
end
