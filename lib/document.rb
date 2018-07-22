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

  def bullets_with_date(date)
    bullets.select { |b| b.date&.to_date == date }
  end
end
