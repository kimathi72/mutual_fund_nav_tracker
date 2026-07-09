# frozen_string_literal: true

module Ml
  class FeatureRowBuilder
    def call(metric)
      {
        mutual_fund_id: metric.mutual_fund_id,
        daily_nav_id: metric.daily_nav_id,

        feature_date: metric.daily_nav.nav_date,

        nav: metric.daily_nav.nav,

        daily_return: metric.daily_return,

        weekly_return: metric.weekly_return,

        monthly_return: metric.monthly_return,

        ytd_return: metric.ytd_return,

        moving_average_7: metric.moving_average_7,

        moving_average_30: metric.moving_average_30,

        volatility_30: metric.volatility_30,

        drawdown: metric.drawdown
      }
    end
  end
end