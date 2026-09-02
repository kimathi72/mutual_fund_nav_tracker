# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

class BrevoEmailService
  API_URL = "https://api.brevo.com/v3/smtp/email"

  def initialize(
    to:,
    subject:,
    html_content:,
    text_content: nil,
    reply_to: nil,
    tags: nil
  )
    @to = to
    @subject = subject
    @html_content = html_content
    @text_content = text_content
    @reply_to = reply_to
    @tags = tags
  end

  def call
    uri = URI.parse(API_URL)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 10
    http.read_timeout = 30

    request = Net::HTTP::Post.new(uri.request_uri)

    request["accept"] = "application/json"
    request["api-key"] = ENV.fetch("BREVO_API_KEY")
    request["content-type"] = "application/json"

    request.body = request_body.to_json

    response = http.request(request)

    handle_response(response)
  end

  private

  def request_body
    body = {
      sender: {
        name: ENV.fetch(
          "BREVO_SENDER_NAME",
          "Mutual Fund Tracker"
        ),
        email: ENV.fetch(
          "BREVO_SENDER_EMAIL"
        )
      },

      to: [
        {
          email: @to
        }
      ],

      subject: @subject,

      htmlContent: @html_content
    }

    body[:textContent] = @text_content if @text_content.present?

    if @reply_to.present?
      body[:replyTo] = {
        email: @reply_to
      }
    end

    body[:tags] = @tags if @tags.present?

    body
  end

  def handle_response(response)
    unless response.is_a?(Net::HTTPSuccess)
      raise BrevoEmailError,
            "Brevo API error #{response.code}: #{response.body}"
    end

    JSON.parse(response.body)
  end

  class BrevoEmailError < StandardError
  end
end