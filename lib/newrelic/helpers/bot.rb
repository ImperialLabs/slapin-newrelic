# frozen_string_literal: true

require 'json'
require 'httparty'

# NewRelic Class Extension
# Bot Helper:
## Helpers to post text or formatted messages via SLAPI
class NewRelic
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
          'text' => text
        }
      },
      headers: {}
    )
    200
  end
end
