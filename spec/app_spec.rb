# frozen_string_literal: true

require 'spec_helper'

describe 'runtime application' do
  let(:app) { Sinatra::Application }

  context 'GET /' do
    it 'returns 200' do
      get '/'
      expect(last_response.status).to eq(200)
    end
  end

  context 'post /codepads/:access_code/:lang' do
    let(:access_code) { 'BBQTIE' }
    let(:lang) { 'ruby' }
    it 'returns 200 with output' do
      code = <<-CODE
        def test(foo)
          puts foo
        end
        test(1)
      CODE

      post "/codepads/#{access_code}/#{lang}",
           code, { 'content-type' => 'application/json',
                   'HTTP_AUTHORIZATION' => 'Bearer test-token' }

      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['output']).to eq("1\n")
    end
  end
end
