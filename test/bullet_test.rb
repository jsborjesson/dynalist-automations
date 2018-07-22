require "test_helper"
require "bullet"

class BulletTest < Minitest::Test
  def test_from_json
    bullet = Bullet.from_json("abcd1234", {
      "id"=>"defg5678",
      "content"=>"The content",
      "note"=>"A note",
      "checked"=>false
    })

    assert_equal "abcd1234", bullet.file_id
    assert_equal "defg5678", bullet.id
    assert_equal "The content", bullet.content
    assert_equal "A note", bullet.note
    assert_equal false, bullet.checked
  end

  def test_checked?
    unchecked_bullet = Factory.bullet(checked: false)
    checked_bullet = Factory.bullet(checked: true)

    refute unchecked_bullet.checked?
    assert checked_bullet.checked?
  end

  def test_tagged_with?
    content_hash_tagged_bullet = Factory.bullet(content: "A content #tagged bullet")
    content_at_tagged_bullet   = Factory.bullet(content: "A content @tagged bullet")
    note_hash_tagged_bullet    = Factory.bullet(note: "A note #tagged bullet")
    note_at_tagged_bullet      = Factory.bullet(note: "A note @tagged bullet")

    refute Factory.bullet.has_tag("tagged")
    assert content_hash_tagged_bullet.has_tag("tagged")
    assert content_at_tagged_bullet.has_tag("tagged")
    assert note_hash_tagged_bullet.has_tag("tagged")
    assert note_at_tagged_bullet.has_tag("tagged")
  end

  def test_date
    content_dated_bullet = Factory.bullet(content: "A content with date !(2018-08-19)")
    note_dated_bullet = Factory.bullet(note: "A note with date !(2018-08-19 16:00)")

    assert_nil Factory.bullet.date
    assert_equal DateTime.new(2018, 8, 19), content_dated_bullet.date
    assert_equal DateTime.new(2018, 8, 19, 16, 0), note_dated_bullet.date
  end

  def test_link

  end
end
