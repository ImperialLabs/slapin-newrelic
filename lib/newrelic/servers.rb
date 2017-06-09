# frozen_string_literal: true

require 'json'
require 'httparty'

# NewRelic Class Extension
# APP Class:
## Contains all interactions with NR servers.json
class NewRelic
  def list_servers(token)
    text = ''
    servers = nr_query(token, 'servers')
    text = build_server_list(servers) if servers['servers']
    attachment('New Relic Server list', 'New Relic Server list', text.join) if servers['servers']
    raise "[ERROR] - App returned #{servers}" unless servers['servers']
  end

  def build_server_list(servers)
    text = []
    servers['servers'].each do |server|
      text << "#{status_set(server)} #{server['name']}\n"
    end
    text
  end
end
