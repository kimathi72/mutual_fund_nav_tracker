# frozen_string_literal: true

module Ml
  class FeatureRowBuilder
    def call(metric)
      {
        mutual_fund_id: metric.mutual_fund_id,
        daily_nav_id: metric.daily_nav_id,
        feature_date: metric.daily_nav.nav_date,

        nav: metric.daily_nav.nav,

        return_1d: metric.return_1d,
        return_7d: metric.return_7d,
        return_30d: metric.return_30d,

        ma_7: metric.ma_7,
        ma_30: metric.ma_30,
        ma_90: metric.ma_90,

        volatility_30: metric.volatility_30,

        momentum: metric.momentum
      }
    end
  end
end