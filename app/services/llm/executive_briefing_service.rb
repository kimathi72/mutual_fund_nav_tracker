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
      existing = cached_briefing

      return existing if existing.present?

      prompt = build_prompt

      response =
        generate_with_llm(prompt)

      Llm::ExecutiveBriefingPersistenceService.new(
        as_of_date: summary.report_date,
        prompt: prompt,
        response: response
      ).call
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
        Report Date: #{summary.report_date}
        Total Funds: #{summary.total_funds}

        Average Daily Return: #{percentage(summary.average_daily_return)}
        Average Weekly Return: #{percentage(summary.average_weekly_return)}
        Average Monthly Return: #{percentage(summary.average_monthly_return)}
        Average YTD Return: #{percentage(summary.average_ytd_return)}

        Average Volatility: #{percentage(summary.average_volatility)}

        Best Performer:

        #{format_fund_summary(summary.best_performer)}

        Worst Performer:

        #{format_fund_summary(summary.worst_performer)}

        Highest Risk:

        #{format_fund_summary(summary.highest_risk)}

        Lowest Risk:

        #{format_fund_summary(summary.lowest_risk)}
      TEXT
    end

    def portfolio_insight_section
      <<~TEXT
        Portfolio Health: #{portfolio_insights.portfolio_health}
        Market Sentiment: #{portfolio_insights.market_sentiment}
        Portfolio Risk: #{portfolio_insights.portfolio_risk}

        Executive Recommendation:

        #{portfolio_insights.executive_recommendation}
      TEXT
    end

    def fund_insight_section
      fund_insights.map do |fund|
        <<~TEXT
          --------------------------------------------------

          #{fund.executive_summary}

          Recommendation:
          #{fund.recommendation}

          Outlook:
          #{fund.market_outlook}

          Opportunity Score:
          #{number(fund.opportunity_score)}

          Risk:
          #{fund.risk_level}

          Confidence:
          #{fund.confidence}
        TEXT
      end.join("\n")
    end

    def format_fund_summary(fund)
      return "N/A" unless fund

      <<~TEXT
        Fund: #{fund.fund_name}
        ISIN: #{fund.isin}
        NAV: #{currency(fund.nav)}
        YTD Return: #{percentage(fund.ytd_return)}
        Volatility: #{percentage(fund.volatility)}
        Maximum Drawdown: #{percentage(fund.drawdown)}
      TEXT
    end

    def generate_with_llm(prompt)
      Llm::Client
        .new
        .chat(prompt)
    end
    def percentage(value, precision: 2)
      return "N/A" if value.blank?

      "#{(value.to_f * 100).round(precision)}%"
    end

    def number(value, precision: 2)
      return "N/A" if value.blank?

      value.to_f.round(precision)
    end

    def currency(value, currency: "USD")
      return "N/A" if value.blank?

      "#{currency} #{format('%.2f', value.to_f)}"
    end
    def cached_briefing
      Llm::ExecutiveBriefingLookupService
        .new(
          as_of_date: summary.report_date
        )
        .call
    end
  end
end