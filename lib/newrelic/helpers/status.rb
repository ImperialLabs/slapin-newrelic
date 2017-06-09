# frozen_string_literal: true

require 'json'
require 'httparty'

# NewRelic Class Extension
# Status:
## Sets emoji status based on NR status color
class NewRelic
  def status_set(query)
    return ':white_check_mark: ' if query['health_status'] == 'green'
    return ':no_entry_sign: ' if query['health_status'] == 'red'
    return ':grey_question: ' unless /(green|red)/.match?(query['health_status'])
  end
end
