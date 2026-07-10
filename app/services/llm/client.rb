# frozen_string_literal: true

module Llm
  class Client
    def chat(prompt)
      raise NotImplementedError,
            "LLM provider not configured."
    end
  end
end