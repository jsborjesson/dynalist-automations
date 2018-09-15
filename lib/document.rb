require "./lib/bullet"

# Represents an entire file and holds all bullet points within
class Document
  attr_reader :id, :bullets

  def initialize(id, bullets)
    @id = id
    @bullets = bullets
  end

  def self.from_json(id, json)
    new(
      id,
      json.fetch("nodes").map { |b| Bullet.from_json(id, b) }
    )
  end

  def with_date(date)
    self.class.new(
      id,
      bullets.select { |b| b.date&.to_date == date }
    )
  end

  def with_tag(tag)
    self.class.new(
      id,
      bullets.select { |b| b.has_tag?(tag) }
    )
  end

  def unchecked
    self.class.new(
      id,
      bullets.reject(&:checked?)
    )
  end

  def bullet(id)
    bullets.find { |b| b.id == id }
  end

  def children(bullet)
    bullet.children_ids.map { |b| bullet(b) }
  end
end
