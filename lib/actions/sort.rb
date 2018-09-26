require "./lib/document_changeset"

class Sort
  attr_reader :document, :api

  TAG = "sort_by_date".freeze

  def initialize(document:, api:)
    @document = document
    @api = api
  end

  def execute
    changeset = DocumentChangeset.new(document.id)

    document.with_tag(TAG).bullets.each do |parent|
      document
        .children(parent)
        .reject { |b| b.date.nil? } # Do not reorder bullets without a date
        .reject { |b| b.checked? } # Do not reorder checked off bullets
        .sort_by(&:date)
        .reverse
        .map { |b| changeset.move(node_id: b.id, parent_id: parent.id, index: 0) }
    end

    api.edit_document(changeset)
  end
end
