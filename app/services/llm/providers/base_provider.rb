# frozen_string_literal: true

module Llm
  module Providers
    class BaseProvider
      MAX_RETRIES = 3
      INITIAL_DELAY = 2.seconds

      private

      def with_retries
        retries = 0

        begin
          yield
        rescue StandardError => e
          retries += 1

          raise e if retries >= MAX_RETRIES

          sleep(INITIAL_DELAY * retries)
          retry
        end
      end
    end
  end
end