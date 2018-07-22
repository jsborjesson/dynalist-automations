class Bullet
  TAG_MARKERS = ["#", "@"]
  DATE_MARKER = /!\((.+)\)/

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

  def date
    # TODO: Handle multiple matches
    date_string = content.match(DATE_MARKER) || note.match(DATE_MARKER)

    DateTime.parse(date_string[1]) unless date_string.nil?
  end
end
