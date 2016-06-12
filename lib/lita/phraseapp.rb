require "lita"
require_relative 'phraseapp_event'

module Lita
  module Handlers
    # Interact with phraseapp via our slack team
    class Phraseapp < Handler

      config :api_key

      http.post "/phraseapp", :phraseapp_event

      def phraseapp_event(request, response)
        event = PhraseappEvent.new(request.body.read)
        robot.trigger(:phraseapp_event, event: event, api_key: config.api_key)
      end

    end

    Lita.register_handler(Phraseapp)
  end
end
