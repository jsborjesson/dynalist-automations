class Dynalist
  def initialize
    @api_base = ENV.fetch("DYNALIST_API_BASE")
    @api_token = ENV.fetch("DYNALIST_API_TOKEN")
  end

  def documents
    make_request("file/list")
  end

  private

  def make_request(endpoint)
    url = [@api_base, endpoint].join("/")
    response = HTTP.post(url, json: { token: @api_token})
    JSON.parse(response)
  end
end
