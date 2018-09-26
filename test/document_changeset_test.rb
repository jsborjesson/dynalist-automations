require "test_helper"
require "document_changeset"

class DocumentChangesetTest < Minitest::Test
  def test_moves
    cs = DocumentChangeset.new("file_id")

    cs.move(node_id: "node1", parent_id: "parent", index: 7)
    cs.move(node_id: "node2", parent_id: "parent", index: 8)

    expected = {
      file_id: "file_id",
      changes: [
        {
          action: "move",
          node_id: "node1",
          parent_id: "parent",
          index: 7
        },
        {
          action: "move",
          node_id: "node2",
          parent_id: "parent",
          index: 8
        }
      ]
    }
    assert_equal expected, cs.to_h
  end

  def test_edits
    cs = DocumentChangeset.new("file_id")

    cs.edit(node_id: "node1", content: "New title")
    cs.edit(node_id: "node2", note: "New note", checked: true)

    expected = {
      file_id: "file_id",
      changes: [
        {
          action: "edit",
          node_id: "node1",
          content: "New title"
        },
        {
          action: "edit",
          node_id: "node2",
          note: "New note",
          checked: true
        }
      ]
    }
    assert_equal expected, cs.to_h
  end
end
