# frozen_string_literal: true

module Llm
  class ExecutiveBriefingLookupService < ApplicationService
    def initialize(as_of_date:)
      @as_of_date = as_of_date
    end

    def call
      ::ExecutiveBriefing
        .where(
          as_of_date: as_of_date,
          status: "success"
        )
        .order(generated_at: :desc)
        .first
    end

    private

    attr_reader :as_of_date
  end
end