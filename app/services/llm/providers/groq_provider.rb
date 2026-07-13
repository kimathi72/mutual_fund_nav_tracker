# frozen_string_literal: true

require "httparty"

module Llm
  module Providers
    class GroqProvider < BaseProvider
      include HTTParty

      base_uri "https://api.groq.com/openai/v1"

      MODEL = "llama-3.3-70b-versatile"

      def generate(prompt)
        response =
          self.class.post(
            "/chat/completions",
            headers: {
              "Authorization" => "Bearer #{api_key}",
              "Content-Type" => "application/json"
            },
            body: payload(prompt).to_json
          )

        parse(response)
      end

      private

      def api_key
        ENV["GROQ_API_KEY"] ||
          Rails.application.credentials.dig(:groq, :api_key)
      end

      def payload(prompt)
        {
          model: MODEL,
          messages: [
            {
                "role": "system",
                "content": "You are the Chief Investment Officer of a multinational asset management firm. Write concise executive briefings for board members."
            },
            {
              role: "user",
              content: prompt
            }
          ],
          temperature: 0.2
        }
      end

      def parse(response)
        return error(response) unless response.success?

        text =
          response.dig(
            "choices",
            0,
            "message",
            "content"
          )

        Llm::ExecutiveBriefing.new(
          generated_by: MODEL,
          generated_at: Time.current,
          briefing: text
        )
      end

      def error(response)
        Llm::ExecutiveBriefing.new(
          generated_by: MODEL,
          generated_at: Time.current,
          briefing: nil,
          error: response.body
        )
      end
    end
  end
end