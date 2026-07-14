# frozen_string_literal: true

class DashboardData
  attr_reader :report_date,
              :funds

  def initialize(
    report_date:,
    funds:
  )
    @report_date = report_date
    @funds = funds

    freeze
  end
end