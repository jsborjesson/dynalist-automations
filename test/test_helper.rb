require "minitest/autorun"
require "webmock/minitest"
require "dotenv"

require "factory"

class DynalistSpy
  attr_reader :changeset

  def edit_document(changeset)
    fail "Called multiple times" unless @changeset.nil?

    @changeset = changeset
  end
end
