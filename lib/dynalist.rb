require "http"

class Dynalist
  def initialize
    @api_base = ENV.fetch("DYNALIST_API_BASE")
    @api_token = ENV.fetch("DYNALIST_API_TOKEN")
  end

  def files
    make_request("file/list")
  end

  def document(file_id)
    make_request("doc/read", file_id: file_id)
  end

  private

  def make_request(endpoint, options = {})
    url = [@api_base, endpoint].join("/")
    body = options.merge(token: @api_token)

    response = HTTP.post(url, json: body)

    JSON.parse(response)
  end
end
