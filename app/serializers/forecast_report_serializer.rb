class ForecastReportSerializer < ApplicationSerializer
  def initialize(report)
    @report = report
  end

  def as_json(*)
    {
      predictions:
        report.predictions.map do |prediction|
          ForecastSerializer.new(prediction).as_json
        end
    }
  end

  private

  attr_reader :report
end