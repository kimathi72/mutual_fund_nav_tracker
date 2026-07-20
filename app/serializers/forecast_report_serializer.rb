# frozen_string_literal: true

class ForecastReportSerializer
  def initialize(report)
    @report = report
  end

  def as_json(*)
    return {} unless report.present?

    {
      fund: report[:fund],

      latest_nav: report[:latest_nav],

      forecasts:
        report[:forecasts].map do |forecast|

          {
            horizon: forecast[:horizon],

            predicted_at: forecast[:predicted_at],

            target_date: forecast[:target_date],

            predicted_nav: forecast[:predicted_nav],

            lower_bound: forecast[:lower_bound],

            upper_bound: forecast[:upper_bound],

            expected_return_pct:
              forecast[:expected_return_pct],

            confidence_score:
              forecast[:confidence_score],

            model_version:
              forecast[:model_version],

            trend:
              forecast[:trend],

            recommendation:
              forecast[:recommendation]
          }

        end
    }
  end

  private

  attr_reader :report
end