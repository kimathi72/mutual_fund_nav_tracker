class PerformanceReport
  attr_reader \
    :fund_id,
    :isin,
    :fund_name,
    :nav_date,
    :latest_nav,
    :currency,
    :daily_return,
    :weekly_return,
    :monthly_return,
    :ytd_return,
    :return_since_30_june_2026,
    :moving_average_7,
    :moving_average_30

  def initialize(
    fund_id:,
    isin:,
    fund_name:,
    nav_date:,
    latest_nav:,
    currency:,
    daily_return:,
    weekly_return:,
    monthly_return:,
    ytd_return:,
    return_since_30_june_2026:,
    moving_average_7:,
    moving_average_30:
  )
    @fund_id = fund_id
    @isin = isin
    @fund_name = fund_name
    @nav_date = nav_date
    @latest_nav = latest_nav
    @currency = currency

    @daily_return = daily_return
    @weekly_return = weekly_return
    @monthly_return = monthly_return
    @ytd_return = ytd_return
    @return_since_30_june_2026 = return_since_30_june_2026

    @moving_average_7 = moving_average_7
    @moving_average_30 = moving_average_30

    freeze
  end
end
