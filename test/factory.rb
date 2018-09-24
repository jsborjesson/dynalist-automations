require "./lib/bullet"
require "./lib/document"
require "securerandom"

class Factory
  def self.bullet(attrs = {})
    Bullet.new(
      id:           attrs[:id]           || SecureRandom.hex,
      content:      attrs[:content]      || "The content",
      note:         attrs[:note]         || "A note",
      checked:      attrs[:checked]      || false,
      file_id:      attrs[:file_id]      || SecureRandom.hex,
      children_ids: attrs[:children_ids] || [],
    )
  end

  def self.document
    Document.from_json("abcd1234", self.document_response)
  end

  def self.files_response
    {
      "_code"=>"Ok",
      "root_file_id"=>"SK4EYgx-6Ovm7ODXCVHJLPLN",
      "files"=>
      [
        {
          "id"=>"DHm5grx7XCauWaMfhw9Wqd-K",
          "title"=>"file 1",
          "type"=>"document",
          "permission"=>4
        },
        {
          "id"=>"i04ycIs7a2b2mbVBRo2ugvRH",
          "title"=>"file 2",
          "type"=>"document",
          "permission"=>4
        },
      ]
    }
  end

  def self.document_response
    {"_code"=>"Ok",
    "title"=>"Automations Test",
    "nodes"=>
      [{"id"=>"root",
        "content"=>"Automations Test",
        "note"=>"",
        "checked"=>false,
        "children"=>["XsONM0ZqP1zm8zYvaNeOGGFc", "xbexUA6PK1ZJ7yHk1UMPbCcv"]},
      {"id"=>"XsONM0ZqP1zm8zYvaNeOGGFc",
        "content"=>"Bullet 1",
        "note"=>"",
        "checked"=>false,
        "children"=>["_0sQw1eAgkbCFbmkigVJpKBP"]},
      {"id"=>"Qp5qIiccr1XuAP6rJL5RX_jt",
        "content"=>"Bullet 2 !(2018-07-22 15:00)",
        "note"=>"",
        "checked"=>false},
      {"id"=>"uT84b0GMNQA2tEF60EQZJ267",
        "content"=>"Bullet 3 !(2018-07-21)",
        "note"=>"",
        "checked"=>false},
      {"id"=>"xbexUA6PK1ZJ7yHk1UMPbCcv",
        "content"=>"Bullet 4",
        "note"=>"!(2018-07-22)",
        "checked"=>false,
        "children"=>["Qp5qIiccr1XuAP6rJL5RX_jt", "uT84b0GMNQA2tEF60EQZJ267"]},
      {"id"=>"_0sQw1eAgkbCFbmkigVJpKBP",
        "content"=>"Bullet 5",
        "note"=>"!(2018-07-20)",
        "checked"=>false}]}
  end
end
