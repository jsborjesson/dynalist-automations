require "http"
require "./lib/document"
require "./lib/bullet"

class Dynalist
  def initialize(env = ENV)
    @api_base = env.fetch("DYNALIST_API_BASE")
    @api_token = env.fetch("DYNALIST_API_TOKEN")
  end

  def files
    make_request("file/list")
  end

  def document(file_id)
    response = make_request("doc/read", file_id: file_id)
    Document.from_json(file_id, response)
  end

  private

  def make_request(endpoint, options = {})
    url = [@api_base, endpoint].join("/")
    body = options.merge(token: @api_token)

    response = HTTP.post(url, json: body)

    JSON.parse(response)
  end
end
