class DocumentChangeset
  attr_reader :file_id, :changes

  def initialize(file_id)
    @file_id = file_id
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

  def to_h
    { file_id: file_id, changes: changes }
  end
end
