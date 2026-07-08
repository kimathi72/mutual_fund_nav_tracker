# frozen_string_literal: true

module Eodhd
  class CandidateRanker 
    def call(candidates, fund)
      return nil if candidates.blank?

      ranked = candidates
                 .map { |candidate| [candidate, score(candidate, fund)] }
                 .sort_by { |(_, score)| -score }

      instrument, confidence = ranked.first

      LookupResult.new(
        instrument: instrument,
        strategy: :name,
        confidence: confidence,
        candidates: candidates.size
      )
    end

    private

    def score(candidate, fund)
      score = 0

      score += 50 if candidate.exchange == "EUFUND"

      score += 25 if candidate.currency == fund.currency

      score += 15 if candidate.security_type == "FUND"

      score += 10 if candidate.country == "Luxembourg"

      score += name_similarity(candidate.name, fund.name)

      score
    end

    def name_similarity(candidate_name, fund_name)
      candidate_words = normalize(candidate_name)
      fund_words      = normalize(fund_name)

      (candidate_words & fund_words).count * 5
    end

    def normalize(text)
      text
        .downcase
        .gsub(/[^a-z0-9 ]/, " ")
        .split
        .uniq
    end
  end
end