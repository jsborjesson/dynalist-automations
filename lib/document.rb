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
    Document.new(
      id,
      bullets.select { |b| b.date&.to_date == date }
    )
  end

  def unchecked
    Document.new(
      id,
      bullets.reject(&:checked?)
    )
  end
end
