# frozen_string_literal: true

module Boursorama
  class HistoryClient < ExternalApi::BaseClient
    HISTORY_PREFIX =
      "https://www.boursorama.com/bourse/opcvm/cours/historique/"

    def history(fund_url)
      response =
        self.class.get(
          history_url(fund_url),
          headers: {
            "User-Agent" => "Mozilla/5.0"
          }
        )

      raise "Unable to fetch history page" unless response.success?

      Parser
        .new(response.body)
        .history
    end

    private

    def history_url(fund_url)
      code =
        URI(fund_url)
          .path
          .split("/")
          .last

      "#{HISTORY_PREFIX}#{code}"
    end
  end
end