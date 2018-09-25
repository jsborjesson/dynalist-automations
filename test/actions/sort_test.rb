require "test_helper"
require "actions/sort"

class SortTest < Minitest::Test
  class DynalistSpy
    attr_reader :file_id, :changes

    def edit_document(file_id, changes)
      fail "Called multiple times" unless @file_id.nil?

      @file_id = file_id
      @changes = changes
    end
  end

  def test_sort
    # Create a document that can be sorted by date
    bullets = [
      second  = Factory.bullet(content: "!(2018-08-10)"),
      checked = Factory.bullet(note: "!(2018-08-10 15:00)", checked: true),
      third   = Factory.bullet(note: "!(2018-08-10 15:15)"),
      no_date = Factory.bullet,
      first   = Factory.bullet(content: "!(2018-08-09)"),
      parent  = Factory.bullet(note: "#sort_by_date", children_ids: [
        second.id,
        third.id,
        no_date.id,
        first.id
      ])
    ]
    doc = Document.new("doc_id", bullets)
    api = DynalistSpy.new

    # Run the sorting algorithm
    action = Sort.new(document: doc, api: api)
    action.execute

    # Verify that edit_document was called with the correct operations
    assert_equal "doc_id", api.file_id

    assert api.changes.all? { |mb| MoveBullet === mb }
    assert api.changes.all? { |mb| mb.parent_id == parent.id }
    assert api.changes.all? { |mb| mb.index == 0 }
    assert_equal [third.id, second.id, first.id], api.changes.map(&:node_id)
  end
end
