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
      briefing = ::ExecutiveBriefing.find_or_initialize_by(
        as_of_date: as_of_date,
        provider: provider,
        model: model
      )

      briefing.assign_attributes(
        status: status,
        prompt: prompt,
        briefing: response.briefing,
        error: response.error,
        generated_at: response.generated_at
      )

      briefing.save!

      briefing
    end

    private

    attr_reader :as_of_date,
                :prompt,
                :response

    def provider
      response.generated_by.to_s.partition("-").first
    end

    def model
      response.generated_by
    end

    def status
      response.error.present? ? "failed" : "success"
    end
  end
end