# frozen_string_literal: true

module Llm
  class ExecutiveBriefingPersistenceService < ApplicationService
    def initialize(
      as_of_date:,
      prompt:,
      response:
    )
      @as_of_date = as_of_date
      @prompt = prompt
      @response = response
    end

    def call
      ::ExecutiveBriefing.create!(
        as_of_date: as_of_date,
        provider: provider,
        model: model,
        status: status,
        prompt: prompt,
        briefing: response.briefing,
        error: response.error,
        generated_at: response.generated_at
      )
    end

    private

    attr_reader :as_of_date,
                :prompt,
                :response

    def provider
      response.generated_by.split("-").first
    end

    def model
      response.generated_by
    end

    def status
      response.error.present? ? "failed" : "success"
    end
  end
end