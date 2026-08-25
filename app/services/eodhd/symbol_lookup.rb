# frozen_string_literal: true

module Eodhd
  class SymbolLookup < ApplicationService
    def initialize(client: Client.new, ranker: CandidateRanker.new)
      @client = client
      @ranker = ranker
    end

    def call(mutual_fund)
      lookup_by_isin(mutual_fund) ||
        lookup_by_name(mutual_fund) ||
        not_found
    end

    private

    attr_reader :client, :ranker

    def lookup_by_isin(mutual_fund)
      matches = client.search(mutual_fund.isin)

      return if matches.empty?

      result = ranker.call(matches, mutual_fund)

      LookupResult.new(
        instrument: result.instrument,
        strategy: :isin,
        confidence: 100,
        candidates: matches.size
      )
    end

    def lookup_by_name(mutual_fund)
      matches = client.search(mutual_fund.name)

      return if matches.empty?

      result = ranker.call(matches, mutual_fund)

      LookupResult.new(
        instrument: result.instrument,
        strategy: :name_fallback,
        confidence: result.confidence,
        candidates: matches.size
      )
    end

    def not_found
      LookupResult.new(
        instrument: nil,
        strategy: :not_found,
        confidence: 0,
        candidates: 0
      )
    end
  end
end