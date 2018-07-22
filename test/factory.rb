class Factory
  def self.bullet(attrs = {})
    Bullet.new(
      id:      attrs[:id] || "defg5678",
      content: attrs[:content] || "The content",
      note:    attrs[:note] || "A note",
      checked: attrs[:checked] || false,
      file_id: attrs[:file_id] || "abcd1234",
    )
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
     "content"=>"One",
     "note"=>"",
     "checked"=>false},
     {"id"=>"Qp5qIiccr1XuAP6rJL5RX_jt",
      "content"=>"a",
      "note"=>"",
      "checked"=>false},
      {"id"=>"uT84b0GMNQA2tEF60EQZJ267",
       "content"=>"b",
       "note"=>"",
       "checked"=>false},
       {"id"=>"xbexUA6PK1ZJ7yHk1UMPbCcv",
        "content"=>"Two",
        "note"=>"",
        "checked"=>false,
        "children"=>["Qp5qIiccr1XuAP6rJL5RX_jt", "uT84b0GMNQA2tEF60EQZJ267"]}]}
  end
end
