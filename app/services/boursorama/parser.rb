# app/services/boursorama/parser.rb

# frozen_string_literal: true

module Boursorama
  class Parser
    def initialize(html)
      @html = html
      @document = Nokogiri::HTML(html)
    end

    def history
      File.write(
        "/tmp/boursorama_history.html",
        @html
      )

      []
    end
  end
end