# frozen_string_literal: true

class RankingSerializer < ApplicationSerializer
  def initialize(rankings)
    @rankings = rankings
  end

  def as_json(*)
    {
      report_date: rankings.report_date,

      top_ytd: serialize(rankings.top_ytd),
      top_monthly: serialize(rankings.top_monthly),
      top_weekly: serialize(rankings.top_weekly),
      top_daily: serialize(rankings.top_daily),

      lowest_risk: serialize(rankings.lowest_risk),
      highest_risk: serialize(rankings.highest_risk),

      largest_drawdown: serialize(rankings.largest_drawdown)
    }
  end

  private

  attr_reader :rankings

  def serialize(records)
    records.map do |record|
      FundRankingSerializer
        .new(record)
        .as_json
    end
  end
end