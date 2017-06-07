
# frozen_string_literal: true
require 'json'
require 'httparty'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/config_file'

# Sinatra API App
class NewRelic < Sinatra::Base
  set :root, File.dirname(__FILE__)
  register Sinatra::ConfigFile

  set :environment, :production

  config_file '../environments.yml'
  config_file '../config/newrelic.yml' if File.file?('../config/newrelic.yml')

  @bot_url = ENV['BOT_URL'] ? ENV['BOT_URL'] : settings.newrelic.bot_url
  @nr_url = 'https://api.newrelic.com/v2/'
  @nr_token = ENV['NR_TOKEN'] ? ENV['NR_TOKEN'] : settings.newrelic.token
  # Future Option
  # @bot_token = ENV['BOT_TOKEN'] ? ENV['BOT_TOKEN'] : settings.new_relic.bot_token

  post '/command' do
    raise 'missing user' unless params[:chat][:user]
    raise 'missing channel' unless params[:chat][:channel]
    raise 'missing type' unless params[:chat][:type]
    raise 'missing timestamp' unless params[:chat][:timestamp]
    raise 'missing command' unless params[:command]
    @params = params
    @command = @params[:command]
    @channel = @params[:chat][:channel]
    @text_array = @params[:chat][:text].split(' ')
    apps if @command[0] == 'search'
    servers if @command[0] == 'save'
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

  def app_query
    HTTParty.get("#{@nr_url}/applications.json", headers: { 'X-Api-Key' => @nr_token })
  end

  def status_set
    returns ':white_check_mark: ' if app['health_status'] == 'green'
    returns ':no_entry_sign: ' if app['health_status'] == 'red'
    returns ':grey_question: ' unless /(green|red)/.match?(app['health_status'])
  end

  def list_apps
    text = ''
    apps = app_query
    apps['applications'].each do |app|
      text << status_set
      text << "#{app['name']}\n"
    end
    attachment('New Relic App list', 'New Relic App list', text)
  end

  def speak(text)
    HTTParty.post(
      "#{@bot_url}/v1/speak",
      body: {
        'channel' => @channel,
        'text' => text
      },
      headers: {}
    )
    nil
  end

  def attachment(fallback, title, text)
    HTTParty.post(
      "#{@bot_url}/v1/attachment",
      body: {
        'channel' => @channel,
        'attachments' => {
          'fallback' => fallback,
          'title' => title,
          'text' => text
        }
      },
      headers: {}
    )
  end
end
