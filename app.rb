# frozen_string_literal: false

require 'sinatra'
require 'sinatra/cors'
require 'pry'
require 'yaml'
require 'etc'
require 'fileutils'

require_relative 'compiler'

set :bind, '0.0.0.0'
set :port, 9494
set :allow_origin, '*'
set :allow_methods, 'GET,PUT,POST,PATCH'
set :allow_headers, 'content-type,authorization'

before { content_type :json }
app_config = YAML.load_file("config/#{ENV['APP_ENV']}.yaml")

get '/' do
  { status: :ok }.to_json
end

post '/codepads/:access_code/:lang' do
  halt 401 if request.env['HTTP_AUTHORIZATION'] != "Bearer #{app_config['auth_token']}"

  # HACK: to avoid hacking
  # make exclusive runtime environment
  FileUtils.rm_rf('/app/runtime/') if ENV['APP_ENV'] == 'prod'
  # end of hacking

  FileUtils.mkdir_p('/hackerpen')
  Dir.chdir('/hackerpen')

  output = Compiler.run(params[:access_code], params['lang'], request.body.read)
  { output: output }.to_json
end
