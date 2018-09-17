class Sort
  attr_reader :document, :api

  TAG = "sort_by_date".freeze

  def initialize(document:, api:)
    @document = document
    @api = api
  end

  def execute
    document.with_tag(TAG).bullets.each do |parent|
      moves = document
        .children(parent)
        .reject { |b| b.date.nil? } # Do not reorder bullets without a date
        .sort_by(&:date)
        .reverse
        .map { |b|
          # Always setting zero gives us a reverse sort without keeping track of an index
          MoveBullet.new(node_id: b.id, parent_id: parent.id, index: 0)
        }

      api.edit_document(document.id, moves)
    end
  end
end
