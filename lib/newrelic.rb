# frozen_string_literal: true

require 'json'
require 'httparty'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/config_file'
require 'yaml'

# Sinatra API App
class NewRelic < Sinatra::Base
  set :root, File.dirname(__FILE__)
  register Sinatra::ConfigFile

  set :environment, :production

  config_file '../environments.yml'

  # Future Option
  # @bot_token = ENV['BOT_TOKEN']

  post '/command' do
    raise 'missing user' unless params[:chat][:user]
    raise 'missing channel' unless params[:chat][:channel]
    raise 'missing command' unless params[:command]
    @params = params
    @command = @params[:command]
    @channel = @params[:chat][:channel]
    list_apps if @command[0] == 'apps'
    list_servers if @command[0] == 'servers'
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

  def list_apps
    text = ''
    @apps = app_query
    text = build_list if @apps['applications']
    attachment('New Relic App list', 'New Relic App list', text) if @apps['applications']
    raise "[ERROR] - App returned #{@apps}" unless @apps['applications']
  end

  def app_query
    HTTParty.get(
      'https://api.newrelic.com/v2/applications.json',
      headers: {
        'X-Api-Key' => ENV['NR_TOKEN']
      }
    )
  end

  def status_set(app)
    return ':white_check_mark: ' if app['health_status'] == 'green'
    return ':no_entry_sign: ' if app['health_status'] == 'red'
    return ':grey_question: ' unless /(green|red)/.match?(app['health_status'])
  end

  def build_list
    text = ["Status | Application \n"]
    @apps['applications'].each do |app|
      text << "#{status_set(app)} #{app['name']}\n"
    end
    text
  end

  def speak(text)
    HTTParty.post(
      "http://#{ENV['BOT_URL']}/v1/speak",
      body: {
        'channel' => @channel,
        'text' => text
      },
      headers: {}
    )
    200
  end

  def attachment(fallback, title, text)
    HTTParty.post(
      "http://#{ENV['BOT_URL']}/v1/attachment",
      body: {
        'channel' => @channel,
        'attachments' => {
          'fallback' => fallback,
          'title' => title,
          'text' => text.join
        }
      },
      headers: {}
    )
    200
  end
end
