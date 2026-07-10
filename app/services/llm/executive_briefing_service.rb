# frozen_string_literal: true

module Llm
  class ExecutiveBriefingService < ApplicationService
    def initialize(
      summary:,
      portfolio_insights:,
      fund_insights:
    )
      @summary = summary
      @portfolio_insights = portfolio_insights
      @fund_insights = fund_insights
    end

    def call
      prompt = build_prompt

      if Rails.env.development?
        simulated_response(prompt)
      else
        generate_with_llm(prompt)
      end
    end

    private

    attr_reader :summary,
                :portfolio_insights,
                :fund_insights

    def build_prompt
      <<~PROMPT
        You are an experienced Chief Investment Officer.

        Produce a concise executive investment briefing.

        ==================================================
        PORTFOLIO SUMMARY
        ==================================================

        #{portfolio_summary_section}

        ==================================================
        PORTFOLIO INTELLIGENCE
        ==================================================

        #{portfolio_insight_section}

        ==================================================
        FUND INSIGHTS
        ==================================================

        #{fund_insight_section}

        Requirements:

        - Maximum 300 words.
        - Executive language.
        - Mention strongest opportunities.
        - Mention highest risks.
        - Mention forecast trends.
        - Finish with one executive recommendation.
      PROMPT
    end

    def portfolio_summary_section
      <<~TEXT
        Report Date: #{summary[:report_date]}
        Total Funds: #{summary[:total_funds]}

        Average Daily Return: #{summary[:average_daily_return]}
        Average Weekly Return: #{summary[:average_weekly_return]}
        Average Monthly Return: #{summary[:average_monthly_return]}
        Average YTD Return: #{summary[:average_ytd_return]}

        Average Volatility: #{summary[:average_volatility]}

        Best Performer:
        #{summary[:best_performer]}

        Worst Performer:
        #{summary[:worst_performer]}

        Highest Risk:
        #{summary[:highest_risk]}

        Lowest Risk:
        #{summary[:lowest_risk]}
      TEXT
    end

    def portfolio_insight_section
      <<~TEXT
        Portfolio Health: #{portfolio_insights[:portfolio_health]}
        Market Sentiment: #{portfolio_insights[:market_sentiment]}
        Portfolio Risk: #{portfolio_insights[:portfolio_risk]}

        Executive Recommendation:

        #{portfolio_insights[:executive_recommendation]}
      TEXT
    end

    def fund_insight_section
      fund_insights.map do |fund|

        <<~TEXT
          --------------------------------------------------

          #{fund[:executive_summary]}

          Recommendation:
          #{fund[:recommendation]}

          Outlook:
          #{fund[:market_outlook]}

          Opportunity Score:
          #{fund[:opportunity_score]}

          Risk:
          #{fund[:risk_level]}

          Confidence:
          #{fund[:confidence]}
        TEXT

      end.join("\n")
    end

    def simulated_response(_prompt)
      {
        generated_by: "simulation",

        briefing:
          "Portfolio performance remains stable with several funds showing positive forecast momentum. "\
          "Most predicted NAV movements remain modest, suggesting controlled market conditions. "\
          "Portfolio diversification continues to reduce downside exposure while a small number of funds "\
          "require closer monitoring due to weaker projected performance. "\
          "Executive management should maintain current allocation, monitor emerging risks, and consider "\
          "increasing exposure to consistently bullish funds."
      }
    end

    def generate_with_llm(prompt)
      Llm::Client
        .new
        .chat(prompt)
    end
  end
end