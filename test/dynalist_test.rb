require "test_helper"
require "dynalist"

class DynalistTest < Minitest::Test
  def fake_env
    {
      "DYNALIST_API_BASE" => "https://dynalist.io/api/v1",
      "DYNALIST_API_TOKEN" => "abcd1234",
    }
  end

  def setup
    @api = Dynalist.new(env: fake_env)
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

    doc = @api.document("file_id")

    assert_equal "file_id", doc.id
    assert_equal 6, doc.bullets.count
    assert doc.bullets.all? { |b| b.kind_of? Bullet }
  end

  def test_move
    expected = {
      "file_id": "file_id",
      "changes": [
        {
          "action": "move",
          "node_id": "abc",
          "parent_id": "xyz",
          "index": 0
        },
        {
          "action": "move",
          "node_id": "def",
          "parent_id": "xyz",
          "index": 0
        },
      ],
      "token": "abcd1234",
    }
    stub_request(:post, "https://dynalist.io/api/v1/doc/edit")
      .to_return(body: { _code: "OK", _msg: ""}.to_json)

    cs = DocumentChangeset.new
    cs.move(node_id: "abc", parent_id: "xyz", index: 0)
    cs.move(node_id: "def", parent_id: "xyz", index: 0)

    @api.edit_document("file_id", cs)

    assert_requested(:post, "https://dynalist.io/api/v1/doc/edit", body: expected.to_json)
  end
end
