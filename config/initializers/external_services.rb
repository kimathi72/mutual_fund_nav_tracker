# frozen_string_literal: true

Rails.application.config.x.external_services = ActiveSupport::OrderedOptions.new

#
# OpenFIGI
#
Rails.application.config.x.external_services.openfigi = ActiveSupport::OrderedOptions.new

Rails.application.config.x.external_services.openfigi.base_url =
  ENV.fetch("OPENFIGI_BASE_URL", "https://api.openfigi.com")

Rails.application.config.x.external_services.openfigi.mapping_endpoint =
  ENV.fetch("OPENFIGI_MAPPING_ENDPOINT", "/v3/mapping")

Rails.application.config.x.external_services.openfigi.api_key =
  ENV.fetch("OPENFIGI_API_KEY", nil)

#
# Yahoo Finance
#
Rails.application.config.x.external_services.yahoo_finance = ActiveSupport::OrderedOptions.new

Rails.application.config.x.external_services.yahoo_finance.base_url =
  ENV.fetch("YAHOO_FINANCE_BASE_URL", "https://query1.finance.yahoo.com")

Rails.application.config.x.external_services.yahoo_finance.chart_endpoint =
  ENV.fetch("YAHOO_FINANCE_CHART_ENDPOINT", "/v8/finance/chart")

#
# Shared HTTP Configuration
#
Rails.application.config.x.external_services.http = ActiveSupport::OrderedOptions.new

Rails.application.config.x.external_services.http.open_timeout =
  ENV.fetch("HTTP_OPEN_TIMEOUT", 5).to_i

Rails.application.config.x.external_services.http.read_timeout =
  ENV.fetch("HTTP_READ_TIMEOUT", 20).to_i

Rails.application.config.x.external_services.http.retry_count =
  ENV.fetch("HTTP_RETRY_COUNT", 3).to_i

Rails.application.config.x.external_services.http.user_agent =
  ENV.fetch(
    "HTTP_USER_AGENT",
    "MutualFundNavTracker/1.0"
  )

Rails.configuration.x.external_services.eodhd = ActiveSupport::OrderedOptions.new

Rails.configuration.x.external_services.eodhd.base_url =
  ENV.fetch("EODHD_BASE_URL")

Rails.configuration.x.external_services.eodhd.api_key =
  ENV.fetch("EODHD_API_KEY")