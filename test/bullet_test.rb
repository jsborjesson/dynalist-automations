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
    title_hash_tagged_bullet = Bullet.from_json(json.merge("content" => "A title #tagged bullet"))
    title_at_tagged_bullet = Bullet.from_json(json.merge("content" => "A title @tagged bullet"))
    note_hash_tagged_bullet = Bullet.from_json(json.merge("note" => "A note #tagged bullet"))
    note_at_tagged_bullet = Bullet.from_json(json.merge("note" => "A note @tagged bullet"))

    refute @bullet.has_tag("tagged")
    assert title_hash_tagged_bullet.has_tag("tagged")
    assert title_at_tagged_bullet.has_tag("tagged")
    assert note_hash_tagged_bullet.has_tag("tagged")
    assert note_at_tagged_bullet.has_tag("tagged")
  end
end
