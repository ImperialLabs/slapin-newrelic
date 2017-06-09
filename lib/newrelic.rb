# frozen_string_literal: true

require 'json'
require 'httparty'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/config_file'

# SLAPIN: New Relic SLAPI Plugin
class NewRelic < Sinatra::Base
  set :root, File.dirname(__FILE__)
  register Sinatra::ConfigFile

  require_relative 'newrelic/servers'
  require_relative 'newrelic/apps'
  require_relative 'newrelic/helpers/bot'
  require_relative 'newrelic/helpers/status'
  require_relative 'newrelic/helpers/query'

  set :environment, :production

  config_file '../environments.yml'

  token = ENV['NR_TOKEN']
  # Future Option
  # @bot_token = ENV['BOT_TOKEN']

  post '/command' do
    raise 'missing user' unless params[:chat][:user]
    raise 'missing channel' unless params[:chat][:channel]
    raise 'missing command' unless params[:command]
    @params = params
    @command = @params[:command]
    @channel = @params[:chat][:channel]
    list_apps(token) if @command[0] == 'apps'
    list_servers(token) if @command[0] == 'servers'
  end

  get '/info' do
    {
      help:
        {
          apps: 'List New Relic Apps',
          servers: 'List New Relic Servers'
        }
    }.to_json
  end
end
