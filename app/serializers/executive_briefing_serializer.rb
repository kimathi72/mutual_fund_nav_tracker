# frozen_string_literal: true

class ExecutiveBriefingSerializer
  def initialize(briefing)
    @briefing = briefing
  end

  def as_json
    return {} unless briefing

    {
      provider: briefing.provider,
      model: briefing.model,
      status: briefing.status,
      generated_at: briefing.generated_at,
      briefing: briefing.briefing,
      error: briefing.error
    }
  end

  private

  attr_reader :briefing
end