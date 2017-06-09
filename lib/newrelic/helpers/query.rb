# frozen_string_literal: true

require 'json'
require 'httparty'

# NewRelic Class Extension
# Query Helper:
## Pulls info from NewRelic, endpoint is dynamic
class NewRelic
  def nr_query(token, endpoint)
    HTTParty.get(
      "https://api.newrelic.com/v2/#{endpoint}.json",
      headers: {
        'X-Api-Key' => token
      }
    )
  end
end
