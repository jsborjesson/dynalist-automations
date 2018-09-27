require "test_helper"
require "actions/repeat"

class RepeatTest < Minitest::Test

  # TODO: Child tasks
  def test_repeat
    # Create a document that can be sorted by date
    bullets = [
      checked_note    = Factory.bullet(content: "l337d", note: "Notes #repeat 14d !(2017-08-31)", checked: true),
      checked_content = Factory.bullet(content: "Title #repeat 1m !(2017-08-31) and stuff", checked: true),
      checked_mixed   = Factory.bullet(content: "Do thing by !(2017-08-31)", note: "Notes #repeat 7d", checked: true),

      no_date          = Factory.bullet,
      unchecked_future = Factory.bullet(note: "#repeat 2d !(2042-08-10 15:15)", checked: false),
      unchecked_past   = Factory.bullet(note: "#repeat 1d !(1999-08-10 15:00)", checked: false),
    ]
    doc = Document.new("doc_id", bullets)
    api = DynalistSpy.new

    # Run the sorting algorithm
    action = Repeat.new(document: doc, api: api)
    action.execute

    # Verify that edit_document was called with the correct operations
    assert_equal "doc_id", api.changeset.file_id
    expected = [
      {
        action: "edit",
        node_id: checked_note.id,
        note: "Notes #repeat 14d !(2017-09-14)",
        checked: false
      },
      {
        action: "edit",
        node_id: checked_content.id,
        content: "Title #repeat 1m !(2017-09-30) and stuff",
        checked: false
      },
      {
        action: "edit",
        node_id: checked_mixed.id,
        content: "Do thing by !(2017-09-07)",
        checked: false
      }
    ]
    assert_equal expected.count, api.changeset.changes.count
    assert_equal expected, api.changeset.changes
  end
end
