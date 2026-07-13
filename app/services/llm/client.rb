# frozen_string_literal: true

module Llm
  class Client
    def initialize(provider: Providers::GroqProvider.new)
      @provider = provider
    end

    def chat(prompt)
      @provider.generate(prompt)
    end
  end
end