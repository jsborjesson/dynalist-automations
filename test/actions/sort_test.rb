require "test_helper"
require "actions/sort"

class SortTest < Minitest::Test
  class DynalistSpy
    attr_reader :file_id, :changeset

    def edit_document(file_id, changeset)
      fail "Called multiple times" unless @file_id.nil?

      @file_id = file_id
      @changeset = changeset
    end
  end

  def test_sort
    # Create a document that can be sorted by date
    bullets = [
      # First parent
      second1 = Factory.bullet(content: "!(2018-08-10)"),
      checked = Factory.bullet(note: "!(2018-08-10 15:00)", checked: true),
      third1  = Factory.bullet(note: "!(2018-08-10 15:15)"),
      first1  = Factory.bullet(content: "!(2018-08-09)"),
      parent1 = Factory.bullet(note: "#sort_by_date", children_ids: [
        second1.id,
        checked.id,
        third1.id,
        first1.id
      ]),

      # Second parent
      second2 = Factory.bullet(content: "!(2018-08-10)"),
      no_date = Factory.bullet,
      first2  = Factory.bullet(content: "!(2018-08-09)"),
      parent2 = Factory.bullet(note: "#sort_by_date", children_ids: [
        second2.id,
        no_date.id,
        first2.id,
      ])
    ]
    doc = Document.new("doc_id", bullets)
    api = DynalistSpy.new

    # Run the sorting algorithm
    action = Sort.new(document: doc, api: api)
    action.execute

    # Verify that edit_document was called with the correct operations
    assert_equal "doc_id", api.file_id
    expected = [
      {
        action: "move",
        node_id: third1.id,
        parent_id: parent1.id,
        index: 0
      },
      {
        action: "move",
        node_id: second1.id,
        parent_id: parent1.id,
        index: 0
      },
      {
        action: "move",
        node_id: first1.id,
        parent_id: parent1.id,
        index: 0
      },
      {
        action: "move",
        node_id: second2.id,
        parent_id: parent2.id,
        index: 0
      },
      {
        action: "move",
        node_id: first2.id,
        parent_id: parent2.id,
        index: 0
      },
    ]
    assert_equal expected, api.changeset.to_a
  end
end
