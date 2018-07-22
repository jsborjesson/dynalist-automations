require "test_helper"
require "bullet"

class BulletTest < Minitest::Test
  def json
    {
      "id"=>"Qp5qIiccr1XuAP6rJL5RX_jt",
      "content"=>"The content",
      "note"=>"A note",
      "checked"=>false
    }
  end

  def setup
    @bullet = Bullet.from_json(json)
  end

  def test_id
    assert_equal "Qp5qIiccr1XuAP6rJL5RX_jt", @bullet.id
  end

  def test_content
    assert_equal "The content", @bullet.content
  end

  def test_note
    assert_equal "A note", @bullet.note
  end

  def test_checked?
    checked_bullet = Bullet.from_json(json.merge("checked" => true))

    refute @bullet.checked?
    assert checked_bullet.checked?
  end

  def test_tagged_with?
    content_hash_tagged_bullet = Bullet.from_json(json.merge("content" => "A content #tagged bullet"))
    content_at_tagged_bullet = Bullet.from_json(json.merge("content" => "A content @tagged bullet"))
    note_hash_tagged_bullet = Bullet.from_json(json.merge("note" => "A note #tagged bullet"))
    note_at_tagged_bullet = Bullet.from_json(json.merge("note" => "A note @tagged bullet"))

    refute @bullet.has_tag("tagged")
    assert content_hash_tagged_bullet.has_tag("tagged")
    assert content_at_tagged_bullet.has_tag("tagged")
    assert note_hash_tagged_bullet.has_tag("tagged")
    assert note_at_tagged_bullet.has_tag("tagged")
  end

  def test_date
    content_dated_bullet = Bullet.from_json(json.merge("content" => "A content with date !(2018-08-19)"))
    note_dated_bullet = Bullet.from_json(json.merge("note" => "A note with date !(2018-08-19 16:00)"))

    assert_nil @bullet.date
    assert_equal DateTime.new(2018, 8, 19), content_dated_bullet.date
    assert_equal DateTime.new(2018, 8, 19, 16, 0), note_dated_bullet.date
  end
end
