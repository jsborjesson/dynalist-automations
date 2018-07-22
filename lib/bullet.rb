class Bullet
  TAG_MARKERS = ["#", "@"]

  attr_reader :id, :content, :note, :checked

  def initialize(id, content, note, checked)
    @id = id
    @content = content
    @note = note
    @checked = checked
  end

  alias_method :checked?, :checked

  def self.from_json(json)
    new(
      json.fetch("id"),
      json.fetch("content"),
      json.fetch("note"),
      json.fetch("checked"),
    )
  end

  def has_tag(tag)
    TAG_MARKERS.any? { |marker| content.match?(marker + tag) || note.match?(marker + tag) }
  end
end
