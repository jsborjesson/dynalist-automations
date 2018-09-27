require "./lib/document_changeset"

class Repeat
  attr_reader :document, :api

  TAG = "repeat".freeze

  def initialize(document:, api:)
    @document = document
    @api = api
  end

  def execute
    changeset = DocumentChangeset.new(document.id)

    document.with_tag(TAG).bullets.each do |bullet|
      if (match = bullet.match(/ (\d{1,3})(d|m|)/)) && bullet.date && bullet.checked?
        interval = match[1].to_i

        updated_text = case match[2]
                       when "d" then bullet.update_date(bullet.date + interval)
                       when "m" then bullet.update_date(bullet.date >> interval)
                       end

        changeset.edit(node_id: bullet.id, checked: false, **updated_text)
      end
    end

    api.edit_document(changeset)
  end
end
