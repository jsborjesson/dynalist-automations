require "http"
require "json"
require "logger"
require "./lib/document"
require "./lib/bullet"

# Communicates with the Dynalist API
class Dynalist
  def initialize(env: ENV, logger: Logger.new("/dev/null"))
    @api_base = env.fetch("DYNALIST_API_BASE")
    @api_token = env.fetch("DYNALIST_API_TOKEN")
    @logger = logger
  end

  def files
    make_request("file/list")
  end

  def document(file_id)
    response = make_request("doc/read", file_id: file_id)
    Document.from_json(file_id, response)
  end

  def edit_document(file_id, changes)
    make_request("doc/edit",
      file_id: file_id,
      changes: Array(changes)
    )
  end

  private

  def make_request(endpoint, options = {})
    url = [@api_base, endpoint].join("/")
    body = options.merge(token: @api_token)

    @logger.debug "POST #{url} #{body}"
    response = HTTP.post(url, json: body)

    JSON.parse(response)
  end
end

class MoveBullet
  attr_reader :action, :node_id, :parent_id, :index

  def initialize(node_id:, parent_id:, index:)
    @action = "move"
    @node_id = node_id
    @parent_id = parent_id
    @index = index
  end

  def to_json(*args)
    {
      action: action,
      node_id: node_id,
      parent_id: parent_id,
      index: index
    }.to_json(*args)
  end
end
