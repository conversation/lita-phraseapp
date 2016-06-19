require "lita"
require_relative 'phraseapp_event'
require_relative 'phraseapp_gateway'

module Lita
  module Handlers
    # Print phraseapp project stats to a channel
    class PhraseappStats < Handler
      config :channel_name

      on :phraseapp_event, :print_event

      def print_event(payload)
        event = payload[:event]
        if event.name == "uploads:processing"
          after(60) do
            print_stats(event)
          end
        end
      end

      private

      def print_stats(event)
        project_id = phraseapp_gateway.project_name_to_id(event.project_name)
        if project_id
          robot.send_message(target, "[phraseapp] #{event.message}\n" + locale_stats_message(project_id))
        end
      end

      def locale_stats_message(project_id)
        locales = phraseapp_gateway.locales(project_id)
        locales_to_message(locales)
      end

      def locales_to_message(locales)
        locales.map { |locale|
          "- #{locale.name}: #{locale.completed}/#{locale.total} (#{locale.percent.to_s("F")}%)"
        }.join("\n")
      end

      def target
        Source.new(room: Lita::Room.find_by_name(config.channel_name) || "general")
      end

      def phraseapp_gateway
        @gateway ||= PhraseappGateway.new(Lita.config.handlers.phraseapp.api_key)
      end

    end

    Lita.register_handler(PhraseappStats)
  end
end
