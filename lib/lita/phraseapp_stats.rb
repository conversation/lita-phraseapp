require "lita"
require "lita-timing"
require "lita/phraseapp_event"
require "lita/phraseapp_gateway"

module Lita
  module Handlers
    # Print phraseapp project stats to a channel
    class PhraseappStats < Handler
      ONE_MINUTE = 60

      config :channel_name

      on :phraseapp_event, :print_event

      def print_event(payload)
        event = payload[:event]
        queue_stats_report(event) if event.name == "uploads:processing"
      end

      private

      def queue_stats_report(event)
        after(ONE_MINUTE) do
          persistent_every("limit-#{event.project_name}", ONE_MINUTE) do
            print_stats(event)
          end
        end
      end

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

      def persistent_every(name, seconds, &block)
        Lita::Timing::RateLimit.new(name, redis).once_every(seconds, &block)
      end

    end

    Lita.register_handler(PhraseappStats)
  end
end
