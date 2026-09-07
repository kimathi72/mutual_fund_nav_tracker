# frozen_string_literal: true

require "base64"

class SendExecutiveReportJob < ApplicationJob
  queue_as :reporting

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 5

  PRIMARY_RECIPIENT = "arundevani@yahoo.uk.com"
  CC_RECIPIENT      = "kimathiwaweru@gmail.com"

  def perform(file_path, report_date = Date.current)
    report_date = Date.parse(report_date.to_s) unless report_date.is_a?(Date)

    unless File.exist?(file_path)
      raise StandardError, "Executive report PDF artifact not found at: #{file_path}"
    end

    Rails.logger.info(
      "[SendExecutiveReportJob] Reading PDF artifact from #{file_path}..."
    )

    pdf_bytes  = File.binread(file_path)
    encoded_pdf = Base64.strict_encode64(pdf_bytes)
    filename   = File.basename(file_path)

    reporting_date_str = report_date.strftime("%d %B %Y")

    html_content = <<~HTML
      <div style="font-family: Arial, sans-serif; color: #243447; line-height: 1.6;">
        <h2 style="color: #1F3A5F;">Executive Portfolio Report</h2>
        <p>Dear Executive Team,</p>
        <p>The latest Mutual Fund Executive Portfolio Briefing for <strong>#{reporting_date_str}</strong> has been generated following today's NAV import and metric calculation cycle.</p>
        <p>The full executive analysis, including portfolio scorecards, risk metrics, forecasts, and individual fund profiles, is attached to this email as a PDF artifact.</p>
        <br/>
        <p style="font-size: 12px; color: #7B8794;">This is an automated system dispatch from the Mutual Fund NAV Tracker platform.</p>
      </div>
    HTML

    text_content = <<~TEXT
      Executive Portfolio Report - #{reporting_date_str}

      Dear sir,

      The latest Mutual Fund Executive Portfolio Briefing for #{reporting_date_str} has been generated following today's NAV import and metric calculation cycle.

      The full executive report is attached to this email as a PDF artifact.

      Mutual Fund NAV Tracker Platform
    TEXT

    Rails.logger.info(
      "[SendExecutiveReportJob] Dispatching email via Brevo to #{PRIMARY_RECIPIENT} (CC: #{CC_RECIPIENT})..."
    )

    BrevoEmailService.new(
      to: PRIMARY_RECIPIENT,
      cc: CC_RECIPIENT,
      subject: "Executive Portfolio Briefing — #{reporting_date_str}",
      html_content: html_content,
      text_content: text_content,
      tags: ["executive-report", "daily-briefing"],
      attachments: [
        {
          name: filename,
          content: encoded_pdf
        }
      ]
    ).call

    Rails.logger.info(
      "[SendExecutiveReportJob] Successfully sent executive report email for #{report_date}."
    )
  end
end