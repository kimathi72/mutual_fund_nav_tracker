# frozen_string_literal: true

module Llm
  class ExecutiveBriefing
    attr_reader :generated_by,
                :generated_at,
                :briefing,
                :error

    def initialize(
      generated_by:,
      briefing:,
      generated_at: Time.current,
      error: nil
    )
      @generated_by = generated_by
      @generated_at = generated_at
      @briefing = briefing
      @error = error
    end

    def success?
      error.blank?
    end
  end
end