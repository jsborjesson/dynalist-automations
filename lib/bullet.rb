class Bullet
  TAG_MARKERS = ["#", "@"]
  DATE_MARKER = /!\((.+)\)/

  attr_reader :id, :content, :note, :checked, :file_id

  def initialize(id:, content:, note:, checked:, file_id:)
    @id      = id
    @content = content
    @note    = note
    @checked = checked
    @file_id = file_id
  end

  alias_method :checked?, :checked

  def self.from_json(file_id, json)
    new(
      file_id: file_id,
      id:      json.fetch("id"),
      content: json.fetch("content"),
      note:    json.fetch("note"),
      checked: json.fetch("checked"),
    )
  end

  def inspect
    %(#<Bullet: "#{content}">)
  end

  def has_tag(tag)
    TAG_MARKERS.any? { |marker| content.match?(marker + tag) || note.match?(marker + tag) }
  end

  def date
    # TODO: Handle multiple matches
    date_string = content.match(DATE_MARKER) || note.match(DATE_MARKER)

    Date.parse(date_string[1]) unless date_string.nil?
  end

  def link
    "https://dynalist.io/d/#{file_id}#z=#{id}"
  end

  def to_html
    <<~HTML
      <li>
        #{content}<br/>
        <small>#{note}</small>
      </li>
    HTML
  end
end
