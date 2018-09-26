class DocumentChangeset
  attr_reader :changes

  alias_method :to_a, :changes

  def initialize
    @changes = []
  end

  def move(node_id:, parent_id:, index:)
    changes << {
      action: "move",
      node_id: node_id,
      parent_id: parent_id,
      index: index
    }
  end

  def edit(node_id:, content: nil, note: nil, checked: nil)
    change = { action: "edit", node_id: node_id }
    change[:content] = content.to_s unless content.nil?
    change[:note]    = note.to_s unless note.nil?
    change[:checked] = !!checked unless checked.nil?
    changes << change
  end
end
