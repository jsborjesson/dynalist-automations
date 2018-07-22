require "test_helper"
require "dynalist"

class DynalistTest < Minitest::Test
  def setup
    @api = Dynalist.new
  end

  def test_files
    stub_request(:post, "https://dynalist.io/api/v1/file/list")
      .with(body: { token: "abcd1234" }.to_json)
      .to_return(body: Factory.files_response.to_json)

    assert_equal Factory.files_response, @api.files
  end

  def test_document
    stub_request(:post, "https://dynalist.io/api/v1/doc/read")
      .with(body: { file_id: "file_id", token: "abcd1234" }.to_json)
      .to_return(body: Factory.document_response.to_json)

    assert_equal Factory.document_response, @api.document("file_id")
  end
end
