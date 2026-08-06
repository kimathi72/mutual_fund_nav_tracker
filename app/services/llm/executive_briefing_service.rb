# frozen_string_literal: true

module Llm
  class ExecutiveBriefingService < ApplicationService
    def initialize(
      summary:,
      portfolio_insights:,
      funds:
    )
      @summary = summary
      @portfolio_insights = portfolio_insights
      @funds = funds
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
                :funds

    ####################################################
    # Prompt
    ####################################################

    def build_prompt
      <<~PROMPT
        You are an executive report writer for an institutional investment platform.

        Your task is to summarize ONLY the information supplied below.

        ============================================================
        IMPORTANT RULES
        ============================================================

        • Use ONLY the supplied data.
        • Never invent facts.
        • Never speculate.
        • Never predict future performance.
        • Never infer market trends.
        • Never reference macroeconomic events.
        • Never reference inflation, interest rates, politics, currencies, geopolitical events or global markets unless explicitly supplied.
        • Never fabricate forecasts.
        • Never explain WHY a metric changed.
        • Never use outside investment knowledge.
        • Never recommend buying, selling or reallocating assets unless explicitly instructed below.

        If information is unavailable, omit it.

        ============================================================
        DEFINITIONS
        ============================================================

        Recommendation

        Buy
        = Quantitative model identifies favorable risk/reward characteristics.

        Hold
        = Quantitative model indicates maintaining the current allocation.

        Sell
        = Quantitative model identifies elevated downside risk.

        Market Outlook

        Bullish
        = Positive quantitative outlook.

        Neutral
        = Mixed quantitative outlook.

        Bearish
        = Negative quantitative outlook.

        Opportunity Score

        1 = High Opportunity

        0 = Normal Opportunity

        ============================================================
        PORTFOLIO SUMMARY
        ============================================================

        #{portfolio_summary_section}

        ============================================================
        PORTFOLIO INSIGHT
        ============================================================

        #{portfolio_insight_section}

        ============================================================
        FUND SNAPSHOTS
        ============================================================

        #{fund_summary_section}

        ============================================================
        REQUIRED OUTPUT
        ============================================================

        Produce EXACTLY four sections.

        1. Portfolio Overview

        Include

        • Portfolio Health
        • Market Sentiment
        • Portfolio Risk
        • Best Performer
        • Worst Performer

        Summarize only the supplied metrics.

        ------------------------------------------------------------

        2. Key Opportunities

        Mention ONLY

        • Funds with Recommendation = Buy
        • Funds with Opportunity = High

        Explain each opportunity ONLY using

        • YTD Return
        • Volatility
        • Drawdown
        • Market Outlook
        • Opportunity Score

        Do NOT infer future performance.

        ------------------------------------------------------------

        3. Key Risks

        Mention ONLY

        • Highest volatility funds
        • Largest drawdown funds
        • Sell recommendations

        Describe ONLY the supplied metrics.

        Do NOT explain causes.

        Do NOT speculate.

        ------------------------------------------------------------

        4. Executive Recommendation

        Repeat the supplied Executive Recommendation.

        You may improve wording for readability.

        Do NOT invent a different recommendation.

        Do NOT recommend buying, selling, reducing exposure or reallocating assets unless explicitly stated in the supplied recommendation.

        ============================================================
        STYLE
        ============================================================

        • Maximum 300 words.
        • Professional.
        • Objective.
        • Concise.
        • Executive audience.
        • Avoid technical jargon.
        • Avoid repetition.
      PROMPT
    end

    ####################################################
    # Portfolio Summary
    ####################################################

    def portfolio_summary_section
      <<~TEXT
        Report Date:
        #{summary.report_date}

        Total Funds:
        #{summary.total_funds}

        Average Daily Return:
        #{percentage(summary.average_daily_return)}

        Average Weekly Return:
        #{percentage(summary.average_weekly_return)}

        Average Monthly Return:
        #{percentage(summary.average_monthly_return)}

        Average YTD Return:
        #{percentage(summary.average_ytd_return)}

        Average Volatility:
        #{percentage(summary.average_volatility)}

        Recommendation Distribution

        Buy:
        #{summary.buy_count}

        Hold:
        #{summary.hold_count}

        Sell:
        #{summary.sell_count}

        Market Outlook Distribution

        Bullish:
        #{summary.bullish_count}

        Bearish:
        #{summary.bearish_count}

        Average Opportunity Score:
        #{number(summary.average_opportunity_score)}

        Best Performer

        #{format_portfolio_fund(summary.best_performer)}

        Worst Performer

        #{format_portfolio_fund(summary.worst_performer)}

        Highest Risk

        #{format_portfolio_fund(summary.highest_risk)}

        Lowest Risk

        #{format_portfolio_fund(summary.lowest_risk)}
      TEXT
    end

    ####################################################
    # Portfolio Insight
    ####################################################

    def portfolio_insight_section
      <<~TEXT
        Portfolio Health:
        #{portfolio_insights.portfolio_health}

        Market Sentiment:
        #{portfolio_insights.market_sentiment}

        Portfolio Risk:
        #{portfolio_insights.portfolio_risk}

        Executive Recommendation:

        #{portfolio_insights.executive_recommendation}
      TEXT
    end

    ####################################################
    # Dashboard Fund Summaries
    ####################################################

    def fund_summary_section
      funds.map do |fund|
        <<~TEXT
          --------------------------------------------------

          Fund:
          #{fund.fund_name}

          ISIN:
          #{fund.isin}

          NAV:
          #{format('%.2f', fund.nav.to_f)}

          Performance

          Daily:
          #{percentage(fund.daily_return)}

          Weekly:
          #{percentage(fund.weekly_return)}

          Monthly:
          #{percentage(fund.monthly_return)}

          YTD:
          #{percentage(fund.ytd_return)}

          Risk

          Volatility:
          #{percentage(fund.volatility)}

          Drawdown:
          #{percentage(fund.drawdown)}

          AI Signals

          Recommendation:
          #{fund.recommendation}

          Market Outlook:
          #{fund.market_outlook}

          
          Opportunity:
          #{OpportunityScore.new(fund.opportunity_score).label}
        TEXT
      end.join("\n")
    end

    ####################################################
    # Helpers
    ####################################################

    ####################################################
# Portfolio Summary Fund (PortfolioFundSummary)
####################################################

    def format_portfolio_fund(fund)
      return "N/A" unless fund

      <<~TEXT
        Fund:
        #{fund.fund_name}

        ISIN:
        #{fund.isin}

        NAV:
        #{format('%.2f', fund.nav.to_f)}

        YTD Return:
        #{percentage(fund.ytd_return)}

        Volatility:
        #{percentage(fund.volatility)}

        Drawdown:
        #{percentage(fund.drawdown)}
      TEXT
    end

    def generate_with_llm(prompt)
      Llm::Client.new.chat(prompt)
    end

    def percentage(value, precision: 2)
      return "N/A" if value.blank?

      "#{(value.to_f * 100).round(precision)}%"
    end

    

    def number(value, precision: 2)
      return "N/A" if value.blank?

      value.to_f.round(precision)
    end

    def cached_briefing
      Llm::ExecutiveBriefingLookupService.new(
        as_of_date: summary.report_date
      ).call
    end
  end
end