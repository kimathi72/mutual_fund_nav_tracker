# frozen_string_literal: true

class GenerateExecutiveReportPdfJob < ApplicationJob
  queue_as :reporting

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 5

  def perform(report_date = Date.current)
    Rails.logger.info(
      "[GenerateExecutiveReportPdfJob] Generating executive report PDF for #{report_date}..."
    )

    # Render PDF bytes from ExecutiveReportPdfService
    pdf_bytes = Reporting::ExecutiveReportPdfService.call

    # Ensure storage/reports directory exists
    reports_dir = Rails.root.join("storage", "reports")
    FileUtils.mkdir_p(reports_dir) unless Dir.exist?(reports_dir)

    filename = "executive_portfolio_report_#{report_date.strftime('%Y-%m-%d')}.pdf"
    file_path = reports_dir.join(filename).to_s

    File.binwrite(file_path, pdf_bytes)

    Rails.logger.info(
      "[GenerateExecutiveReportPdfJob] Saved PDF artifact to #{file_path}"
    )

    # Chain to email dispatch job
    SendExecutiveReportJob.perform_later(file_path, report_date)

    Rails.logger.info(
      "[GenerateExecutiveReportPdfJob] Enqueued SendExecutiveReportJob for #{report_date}."
    )
  end
end