require "http"
require "json"
require "logger"
require "./lib/document"
require "./lib/bullet"
require "./lib/document_changeset"

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

  def edit_document(changeset)
    fail ArgumentError unless changeset.kind_of?(DocumentChangeset)

    make_request("doc/edit", changeset.to_h) unless changeset.changes.empty?
  end

  private

  def make_request(endpoint, options = {})
    url = [@api_base, endpoint].join("/")
    body = options.merge(token: @api_token)

    @logger.debug "POST #{url} #{body.to_json}"
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

  def to_h
    {
      action: action,
      node_id: node_id,
      parent_id: parent_id,
      index: index
    }
  end
end
