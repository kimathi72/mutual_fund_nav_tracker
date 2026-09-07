# frozen_string_literal: true

module Llm
  class ExecutiveBriefing
    attr_reader :provider,
                :model,
                :generated_at,
                :briefing,
                :error

    def initialize(
      provider:,
      model:,
      briefing:,
      generated_at: Time.current,
      error: nil
    )
      @provider = provider
      @model = model
      @generated_at = generated_at
      @briefing = briefing
      @error = error
    end

    def success?
      error.blank?
    end
  end
end
