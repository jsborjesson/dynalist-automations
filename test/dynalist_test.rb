require "test_helper"
require "dynalist"

class DynalistTest < Minitest::Test
  def response
    {
      "_code"=>"Ok",
      "root_file_id"=>"SK4EYgx-6Ovm7ODXCVHJLPLN",
      "files"=>
      [
        {
          "id"=>"DHm5grx7XCauWaMfhw9Wqd-K",
          "title"=>"Document 1",
          "type"=>"document",
          "permission"=>4
        },
        {
          "id"=>"i04ycIs7a2b2mbVBRo2ugvRH",
          "title"=>"Document 2",
          "type"=>"document",
          "permission"=>4
        },
      ]
    }
  end

  def setup
  end

  def test_documents
    stub_request(:post, "https://dynalist.io/api/v1/file/list")
      .with(body: { token: "abcd1234" }.to_json)
      .to_return(body: response.to_json)

    api = Dynalist.new

    assert_equal response, api.documents
  end
end
