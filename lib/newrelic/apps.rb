# frozen_string_literal: true

require 'json'
require 'httparty'

# NewRelic Class Extension
# APP Class:
## Contains all interactions with NR applications.json
class NewRelic
  def list_apps(token)
    text = ''
    apps = nr_query(token, 'applications')
    text = build_app_list(apps) if apps['applications']
    attachment('New Relic App list', 'New Relic App list', text.join) if apps['applications']
    raise "[ERROR] - App returned #{apps}" unless apps['applications']
  end

  def build_app_list(apps)
    text = []
    apps['applications'].each do |app|
      text << "#{status_set(app)} #{app['name']}\n"
    end
    text
  end
end
