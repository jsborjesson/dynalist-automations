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

  def test_inspect
    assert_equal '#<Bullet: "The content">', Factory.bullet(content: "The content").inspect
  end

  def test_tagged_with?
    content_hash_tagged_bullet = Factory.bullet(content: "A content #tagged bullet")
    content_at_tagged_bullet   = Factory.bullet(content: "A content @tagged bullet")
    note_hash_tagged_bullet    = Factory.bullet(note: "A note #tagged bullet")
    note_at_tagged_bullet      = Factory.bullet(note: "A note @tagged bullet")

    refute Factory.bullet.has_tag?("tagged")
    assert content_hash_tagged_bullet.has_tag?("tagged")
    assert content_at_tagged_bullet.has_tag?("tagged")
    assert note_hash_tagged_bullet.has_tag?("tagged")
    assert note_at_tagged_bullet.has_tag?("tagged")
  end

  def test_match
    b1 = Factory.bullet(content: "Stuff 123 and things", note: "456 etc")
    b2 = Factory.bullet(content: "Stuff and things", note: "789 etc")
    b3 = Factory.bullet

    assert_equal "123", b1.match(/\d{3}/)[0]
    assert_equal "789", b2.match(/\d{3}/)[0]
    assert_nil b3.match(/\d{3}/)
  end

  def test_date
    content_dated_bullet = Factory.bullet(content: "A content with date !(2018-08-19) (and other shit)")
    note_dated_bullet = Factory.bullet(note: "#due !(2018-09-02) (Halva priset på leverans)")

    assert_nil Factory.bullet.date
    assert_equal Date.new(2018, 8, 19), content_dated_bullet.date
    assert_equal Date.new(2018, 9, 2), note_dated_bullet.date
  end

  def test_update_date
    b1 = Factory.bullet(content: "Content !(2018-08-09 15:15) and things")
    b2 = Factory.bullet(note: "Note !(2018-08-09) and things")
    b3 = Factory.bullet(note: "Stuff and things")
    b4 = Factory.bullet(note: "")

    assert_equal ({ content: "Content !(2019-01-01) and things" }), b1.update_date(Date.new(2019, 01, 01))
    assert_equal ({ note: "Note !(2019-01-01) and things" }),       b2.update_date(Date.new(2019, 01, 01))
    assert_equal ({ note: "Stuff and things !(2019-01-01)" }),      b3.update_date(Date.new(2019, 01, 01))
    assert_equal ({ note: "!(2019-01-01)" }),                       b4.update_date(Date.new(2019, 01, 01))
  end

  def test_link
    bullet = Factory.bullet(file_id: "wvixjccy61qVpesh489VTCUt", id: "Qp5qIiccr1XuAP6rJL5RX_jt")

    assert_equal "https://dynalist.io/d/wvixjccy61qVpesh489VTCUt#z=Qp5qIiccr1XuAP6rJL5RX_jt", bullet.link
  end

  def test_to_html
    bullet = Factory.bullet(
      id: "defg5678",
      file_id: "abcd1234",
      content: "The [content](https://dynalist.io/d/asdfgh)",
      note: "A note !(2018-08-09)",
    )

    assert_equal <<~HTML, bullet.to_html
      <a href="https://dynalist.io/d/abcd1234#z=defg5678">
        <li>
          <div><b>The content</b></div>
          <div><i>A note 2018-08-09</i></div>
        </li>
      </a>
    HTML
  end
end
