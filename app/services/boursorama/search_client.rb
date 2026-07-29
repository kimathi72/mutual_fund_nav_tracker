# frozen_string_literal: true

module Boursorama
  class SearchClient < ExternalApi::BaseClient
    SEARCH_URL = "https://www.boursorama.com/recherche/"

    def find_url(isin:, name: nil)
      search(isin) ||
        search(name)
    end

    private

    def search(query)
      return nil if query.blank?

      html =
        self.class.get(
          "#{SEARCH_URL}?query=#{CGI.escape(query)}",
          headers: {
            "User-Agent" => "Mozilla/5.0"
          }
        )

      return nil unless html.success?

      document =
        Nokogiri::HTML(html.body)

      link =
        document.at_css(
          'a[href*="/bourse/opcvm/cours/"]'
        )

      return nil unless link

      normalize_url(link["href"])
    end

    def normalize_url(path)
      return nil if path.blank?

      if path.start_with?("http")
        path
      else
        "https://www.boursorama.com#{path}"
      end
    end
  end
end