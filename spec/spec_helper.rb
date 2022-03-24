# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require_relative '../app'
require_relative '../compiler'

require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
