# frozen_string_literal: true

require "httparty"

module Llm
  module Providers
    class GeminiProvider < BaseProvider
      include HTTParty

      base_uri "https://generativelanguage.googleapis.com"

      MODEL = "gemini-2.5-pro"

      def generate(prompt)
        with_retries do
          response =
            self.class.post(
              "/v1beta/models/#{MODEL}:generateContent",
              query: { key: api_key },
              headers: {
                "Content-Type" => "application/json"
              },
              body: payload(prompt).to_json
            )

          parse(response)
        end
      end

      private

      def api_key
        ENV["GEMINI_API_KEY"] ||
          Rails.application.credentials.dig(:gemini, :api_key)
      end

      def payload(prompt)
        {
          contents: [
            {
              parts: [
                {
                  text: prompt
                }
              ]
            }
          ]
        }
      end

      def parse(response)
        return error(response) unless response.success?

        text =
          response.dig(
            "candidates",
            0,
            "content",
            "parts",
            0,
            "text"
          )

        Llm::ExecutiveBriefing.new(
          generated_by: MODEL,
          briefing: text
        )
      end

      def error(response)
        Llm::ExecutiveBriefing.new(
          generated_by: MODEL,
          briefing: nil,
          error: response.body
        )
      end
    end
  end
end