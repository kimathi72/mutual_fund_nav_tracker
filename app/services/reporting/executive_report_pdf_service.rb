

require "prawn"
require "prawn/table"

module Reporting
  class ExecutiveReportPdfService < ApplicationService
    BASELINE_DATE = Date.new(2026, 6, 30)

    FONT_REGULAR = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
    FONT_BOLD    = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"

    PAGE_MARGINS = {
      top: 42,
      right: 42,
      bottom: 50,
      left: 42
    }.freeze

    COLORS = {
      navy:       "1F3A5F",
      dark:       "243447",
      slate:      "52606D",
      muted:      "7B8794",
      border:     "D9E2EC",
      grid:       "E5E7EB",
      light:      "F1F5F9",
      lighter:    "F8FAFC",
      white:      "FFFFFF",
      positive:   "3A7D44",
      negative:   "B94A48",
      accent:     "334E68"
    }.freeze

    FORECAST_HORIZONS = %w[1d 30d 90d].freeze

    def initialize(report: nil)
      @report = report
      @toc_entries = []
      @toc_page = nil
    end

    def call
      @report ||= Reporting::Dashboard::ExecutiveDashboardService.call

      Prawn::Document.new(
        page_size: "A4",
        page_margins: PAGE_MARGINS
      ) do |pdf|
        configure_document(pdf)

        # PAGE 1 — COVER PAGE
        add_header(pdf)
        @toc_page = pdf.page_number
        add_toc_placeholder(pdf)

        # PAGE 2 — EXECUTIVE OVERVIEW
        pdf.start_new_page
        register_section(pdf, "1. Executive Overview")
        add_executive_overview(pdf)

        # PAGE 3 — PORTFOLIO SCORECARD
        pdf.start_new_page
        register_section(pdf, "2. Portfolio Scorecard")
        add_portfolio_scorecard(pdf)

        # PAGE 4 — PERFORMANCE & TRENDS
        pdf.start_new_page
        register_section(pdf, "3. Performance & Portfolio Trends")
        add_performance_section(pdf)

        # PAGE 5 — RISK & OPPORTUNITY ANALYTICS
        pdf.start_new_page
        register_section(pdf, "4. Risk & Opportunity")
        add_risk_opportunity_section(pdf)

        # PAGE 6+ — DETAILED FUND PROFILES & NAV CHARTS
        pdf.start_new_page
        register_section(pdf, "5. Fund Profiles")
        add_fund_profiles(pdf)

        # FOOTER & DYNAMIC TOC PASS
        add_footer(pdf)
        render_table_of_contents(pdf)
      end.render
    end

    private

    # ============================================================
    # DOCUMENT CONFIGURATION
    # ============================================================

    def configure_document(pdf)
      if File.exist?(FONT_REGULAR) && File.exist?(FONT_BOLD)
        pdf.font_families.update(
          "DejaVu" => {
            normal: FONT_REGULAR,
            bold: FONT_BOLD
          }
        )

        pdf.font "DejaVu"
      else
        pdf.font "Helvetica"
      end

      pdf.font_size 9
      pdf.default_leading 3
      pdf.fill_color COLORS[:dark]
      pdf.stroke_color COLORS[:border]
    end

    # ============================================================
    # HEADER
    # ============================================================

    def add_header(pdf)
      pdf.fill_color COLORS[:navy]

      pdf.text(
        "MUTUAL FUND TRACKER",
        size: 10,
        style: :bold,
        character_spacing: 0.8
      )

      pdf.move_down 7

      pdf.text(
        "Executive Portfolio Report",
        size: 25,
        style: :bold
      )

      pdf.move_down 6

      pdf.fill_color COLORS[:slate]

      pdf.text(
        "As of #{report_date.strftime('%d %B %Y')} | Baseline: #{BASELINE_DATE.strftime('%d %B %Y')} ",
        size: 10
      )

      pdf.move_down 3

      pdf.text(
        "Generated #{generated_at.strftime('%d %B %Y at %H:%M UTC')}",
        size: 8
      )

      pdf.move_down 15

      pdf.stroke_color "B8C7D9"
      pdf.stroke_horizontal_rule

      pdf.move_down 15

      pdf.fill_color COLORS[:dark]
    end

    # ============================================================
    # TABLE OF CONTENTS
    # ============================================================

    def register_section(pdf, title)
        # Generate a unique anchor key per section (e.g. "section_1_executive_overview")
        dest_name = "dest_#{title.parameterize.underscore}"

        # Register destination anchor at current page position
        pdf.add_dest(dest_name, pdf.dest_fit(pdf.page))

        @toc_entries << {
            title: title,
            page: pdf.page_number,
            dest: dest_name
        }
    end

    def add_toc_placeholder(pdf)
      pdf.fill_color COLORS[:navy]
      pdf.text("Table of Contents", size: 20, style: :bold)

      pdf.move_down 7

      pdf.fill_color COLORS[:slate]
      pdf.text(
        "Executive report structure and section guide",
        size: 9
      )

      pdf.move_down 20

      pdf.stroke_color COLORS[:border]
      pdf.stroke_horizontal_rule

      pdf.move_down 20

      pdf.fill_color COLORS[:muted]
      pdf.text(
        "Contents will be populated with final section page numbers.",
        size: 8
      )
    end

    def add_section_header(pdf, title, subtitle = nil)
      pdf.fill_color COLORS[:navy]

      pdf.text(
        title,
        size: 16,
        style: :bold
      )

      pdf.move_down 4

      if subtitle.present?
        pdf.fill_color COLORS[:slate]

        pdf.text(
          subtitle,
          size: 8.5,
          leading: 3
        )

        pdf.move_down 10
      else
        pdf.move_down 6
      end

      pdf.stroke_color COLORS[:border]
      pdf.line_width = 0.5
      pdf.stroke_horizontal_rule

      pdf.move_down 14

      pdf.fill_color COLORS[:dark]
    end

    def render_table_of_contents(pdf)
        return unless @toc_page

        pdf.go_to_page(@toc_page)

        header_bottom_y = 700

        pdf.fill_color COLORS[:white]

        pdf.fill_rectangle(
            [0, header_bottom_y],
            pdf.bounds.width,
            header_bottom_y
        )

        pdf.move_cursor_to(header_bottom_y - 10)

        pdf.fill_color COLORS[:navy]

        pdf.text(
            "Contents",
            size: 18,
            style: :bold
        )

        pdf.move_down 5

        pdf.fill_color COLORS[:slate]

        pdf.text(
            "Executive report structure and section guide",
            size: 8.5
        )

        pdf.move_down 14

        pdf.stroke_color COLORS[:border]
        pdf.stroke_horizontal_rule

        pdf.move_down 14

        @toc_entries.each do |entry|
            pdf.fill_color COLORS[:dark]

            current_y = pdf.cursor
            row_height = 18
            width = pdf.bounds.width

            # Formatted text box with anchor parameter
            pdf.formatted_text_box(
            [
                {
                text: clean_text(entry[:title]),
                styles: [:bold],
                size: 9.5,
                color: COLORS[:dark],
                anchor: entry[:dest]
                }
            ],
            at: [0, current_y],
            width: width - 55,
            height: row_height
            )

            pdf.formatted_text_box(
            [
                {
                text: entry[:page].to_s,
                styles: [:bold],
                size: 9.5,
                color: COLORS[:dark],
                anchor: entry[:dest]
                }
            ],
            at: [width - 35, current_y],
            width: 35,
            height: row_height,
            align: :right
            )

            # Optional: Draw an invisible interactive rectangle across the full row area
            pdf.link_annotation(
            [0, current_y - row_height, width, current_y],
            Dest: entry[:dest],
            Border: [0, 0, 0]
            )

            pdf.move_down 20

            pdf.stroke_color COLORS[:grid]
            pdf.stroke_horizontal_rule

            pdf.move_down 8
        end

        pdf.move_cursor_to(pdf.bounds.bottom + 25)

        pdf.fill_color COLORS[:muted]

        pdf.text(
            "Reporting basis: portfolio data through #{report_date.strftime('%d %B %Y')}.",
            size: 7.5
        )
    end

    # ============================================================
    # EXECUTIVE OVERVIEW
    # ============================================================

    def add_executive_overview(pdf)
      add_section_header(
        pdf,
        "1. Executive Overview",
        "High-level summary of portfolio health, market sentiment, and core metrics."
      )

      insight = report_value(:portfolio_insight)
      summary = report_value(:summary)

      snapshot_cards(
        pdf,
        [
          [
            "Portfolio Health",
            display_value(value_from(insight, :portfolio_health))
          ],
          [
            "Market Sentiment",
            display_value(value_from(insight, :market_sentiment))
          ],
          [
            "Portfolio Risk",
            display_value(value_from(insight, :portfolio_risk))
          ],
          [
            "Total Funds",
            integer_value(value_from(summary, :total_funds))
          ]
        ]
      )

      pdf.move_down 20

      add_executive_recommendation(pdf)

      pdf.move_down 20

      add_executive_context(pdf)
    end

    def snapshot_cards(pdf, cards)
      columns = 4
      gap = 8

      card_width =
        (pdf.bounds.width - (gap * (columns - 1))) /
        columns.to_f

      card_height = 62
      start_y = pdf.cursor

      cards.each_with_index do |(label, value), index|
        col = index % columns
        row = index / columns

        x = col * (card_width + gap)
        y = start_y - (row * (card_height + gap))

        pdf.fill_color COLORS[:light]

        pdf.fill_rounded_rectangle(
          [x, y],
          card_width,
          card_height,
          6
        )

        pdf.fill_color COLORS[:slate]

        pdf.text_box(
          clean_text(label),
          at: [x, y - 12],
          width: card_width,
          height: 12,
          size: 6.5,
          align: :center
        )

        pdf.fill_color COLORS[:navy]

        pdf.text_box(
          clean_text(value),
          at: [x, y - 32],
          width: card_width,
          height: 20,
          size: 11,
          style: :bold,
          align: :center
        )
      end

      total_rows = (cards.length / columns.to_f).ceil

      pdf.move_down(
        total_rows * (card_height + gap)
      )
    end

    def add_executive_recommendation(pdf)
      insight = report_value(:portfolio_insight)

      recommendation =
        display_value(
          value_from(
            insight,
            :executive_recommendation
          )
        )

      recommendation =
        "No executive recommendation available." if recommendation == "N/A"

      height = 72
      top = pdf.cursor
      width = pdf.bounds.width

      pdf.fill_color COLORS[:light]

      pdf.fill_rounded_rectangle(
        [0, top],
        width,
        height,
        7
      )

      pdf.fill_color COLORS[:navy]

      pdf.text_box(
        "EXECUTIVE RECOMMENDATION",
        at: [16, top - 14],
        width: width - 32,
        height: 12,
        size: 7,
        style: :bold
      )

      pdf.fill_color COLORS[:dark]

      pdf.text_box(
        clean_text(recommendation),
        at: [16, top - 34],
        width: width - 32,
        height: 30,
        size: 10,
        style: :bold,
        leading: 4
      )

      pdf.move_down height + 5
    end

    def add_executive_context(pdf)
      section_subtitle(
        pdf,
        "Executive Context"
      )

      insight = report_value(:portfolio_insight)

      health =
        display_value(
          value_from(
            insight,
            :portfolio_health
          )
        )

      sentiment =
        display_value(
          value_from(
            insight,
            :market_sentiment
          )
        )

      risk =
        display_value(
          value_from(
            insight,
            :portfolio_risk
          )
        )

      text =
        "The portfolio is currently assessed as #{health.downcase}, " \
        "with #{sentiment.downcase} market sentiment and #{risk.downcase} " \
        "portfolio risk. Detailed fund-level measurements are consolidated " \
        "in the Portfolio Scorecard, while the following sections focus on " \
        "performance trends, risk positioning and fund-specific outlook."

      pdf.fill_color COLORS[:dark]

      pdf.text(
        clean_text(text),
        size: 8.5,
        leading: 4.5
      )
    end

    # ============================================================
    # PORTFOLIO SCORECARD
    # ============================================================

    def add_portfolio_scorecard(pdf)
      add_section_header(
        pdf,
        "2. Portfolio Scorecard",
        "Comprehensive quantitative reference for fund-level metrics and overall scores."
      )

      pdf.fill_color COLORS[:slate]

      pdf.text(
        "The scorecard is the single reference point for the portfolio's " \
        "current quantitative position.",
        size: 8,
        leading: 4
      )

      pdf.move_down 12

      add_scorecard_table(pdf)

      pdf.move_down 18

      add_portfolio_extremes(
        pdf,
        report_value(:summary)
      )
    end

    def add_scorecard_table(pdf)
      headers = [
        "Fund",
        "NAV",
        "YTD",
        "Since\n30 Jun",
        "Vol.",
        "DD",
        "Opp.",
        "Score"
      ]

      rows = funds.map do |fund|
        [
          truncate(fund_name(fund), 31),
          number(value_from(fund, :nav)),
          percentage(value_from(fund, :ytd_return)),
          percentage(
            value_from(
              fund,
              :return_since_30_june_2026
            )
          ),
          percentage(
            value_from(
              fund,
              :volatility
            )
          ),
          percentage(
            value_from(
              fund,
              :drawdown
            )
          ),
          number(
            value_from(
              fund,
              :opportunity_score
            )
          ),
          number(
            value_from(
              fund,
              :portfolio_score
            )
          )
        ]
      end

      data = [headers] + rows

      pdf.table(
        data,
        header: true,
        column_widths: [
          160,
          48,
          48,
          55,
          52,
          52,
          48,
          49
        ],
        cell_style: {
          padding: 5,
          size: 6.8,
          valign: :center,
          overflow: :shrink_to_fit
        }
      ) do |table|
        style_table_header(table)

        table.rows(1..-1).each_with_index do |row, index|
          row.background_color =
            index.even? ?
              COLORS[:lighter] :
              COLORS[:white]

          row.text_color = COLORS[:dark]
        end

        funds.each_with_index do |fund, index|
          row_idx = index + 1

          val =
            numeric_value(
              value_from(
                fund,
                :return_since_30_june_2026
              )
            )

          target_cell =
            table.cells[row_idx, 3]

          target_cell.text_color =
            val >= 0 ?
              COLORS[:positive] :
              COLORS[:negative]

          target_cell.font_style = :bold
        end

        table.column(0).font_style = :bold
        table.column(0).align = :left
        table.columns(1..-1).align = :center
      end
    end

    def add_portfolio_extremes(pdf, summary)
      section_subtitle(
        pdf,
        "Portfolio Leaders & Laggards"
      )

      best =
        fund_name(
          value_from(
            summary,
            :best_performer
          )
        )

      worst =
        fund_name(
          value_from(
            summary,
            :worst_performer
          )
        )

      highest_risk =
        fund_name(
          value_from(
            summary,
            :highest_risk
          )
        )

      lowest_risk =
        fund_name(
          value_from(
            summary,
            :lowest_risk
          )
        )

      rows = [
        ["Best YTD performer", best],
        ["Weakest YTD performer", worst],
        ["Highest volatility", highest_risk],
        ["Lowest volatility", lowest_risk]
      ]

      add_compact_definition_table(
        pdf,
        rows
      )
    end

    # ============================================================
    # PERFORMANCE & TRENDS
    # ============================================================

    def add_performance_section(pdf)
      add_section_header(
        pdf,
        "3. Performance & Portfolio Trends",
        "Comparative return trajectories across YTD and baseline periods."
      )

      pdf.fill_color COLORS[:slate]

      pdf.text(
        "Performance trends across portfolio holdings.",
        size: 8,
        leading: 4
      )

      pdf.move_down 12

      add_chart_box(
        pdf,
        "YTD Return by Fund",
        195
      ) do
        draw_bar_chart(
          pdf,
          records: funds,
          value_method: :ytd_return,
          value_formatter: ->(value) {
            percentage(value)
          },
          show_value_labels: true
        )
      end

      pdf.move_down 14

      add_chart_box(
        pdf,
        "Return Since 30 June 2026",
        195
      ) do
        draw_bar_chart(
          pdf,
          records: funds,
          value_method: :return_since_30_june_2026,
          value_formatter: ->(value) {
            percentage(value)
          },
          show_value_labels: true
        )
      end
    end

    # ============================================================
    # RISK & OPPORTUNITY
    # ============================================================

    def add_risk_opportunity_section(pdf)
      add_section_header(
        pdf,
        "4. Risk & Opportunity",
        "Analysis of volatility, maximum drawdowns, and risk-return positioning."
      )

      pdf.fill_color COLORS[:slate]

      pdf.text(
        "Risk positioning is shown through volatility, drawdown and risk-return relationships.",
        size: 8,
        leading: 4
      )

      pdf.move_down 12

      add_chart_box(
        pdf,
        "Risk vs Return",
        215
      ) do
        draw_scatter_chart(
          pdf,
          records: funds
        )
      end

      pdf.move_down 14

      add_chart_box(
        pdf,
        "Maximum Drawdown by Fund",
        195
      ) do
        draw_bar_chart(
          pdf,
          records: funds,
          value_method: :drawdown,
          value_formatter: ->(value) {
            percentage(value)
          },
          show_value_labels: true
        )
      end

      pdf.move_down 16

      add_risk_leader_table(pdf)
    end

    def add_risk_leader_table(pdf)
      rankings =
        report_value(:rankings)

      section_subtitle(
        pdf,
        "Risk Positioning"
      )

      highest =
        ranking_records(
          value_from(
            rankings,
            :highest_risk
          )
        )

      drawdowns =
        ranking_records(
          value_from(
            rankings,
            :largest_drawdown
          )
        )

      lowest =
        ranking_records(
          value_from(
            rankings,
            :lowest_risk
          )
        )

      rows = [
        [
          "Highest Volatility",
          highest.first ?
            fund_name(highest.first) :
            "N/A"
        ],
        [
          "Largest Drawdown",
          drawdowns.first ?
            fund_name(drawdowns.first) :
            "N/A"
        ],
        [
          "Lowest Volatility",
          lowest.first ?
            fund_name(lowest.first) :
            "N/A"
        ]
      ]

      add_compact_definition_table(
        pdf,
        rows
      )
    end

    # ============================================================
    # FUND PROFILES & CHARTS SECTION
    # ============================================================

    def add_fund_profiles(pdf)
      add_section_header(
        pdf,
        "5. Fund Profiles",
        "Detailed individual fund breakdowns with historical NAV trajectories."
      )

      pdf.fill_color COLORS[:slate]

      pdf.text(
        "Individual fund profiles featuring core metrics, qualitative positioning, and historical NAV charts.",
        size: 8,
        leading: 4
      )

      pdf.move_down 15

      funds.each_with_index do |fund, index|
        add_fund_profile(
          pdf,
          fund
        )

        next if index == funds.length - 1

        if pdf.cursor < 340
          pdf.start_new_page
        else
          pdf.move_down 16
        end
      end
    end

    # IMPORTANT:
    # Keep these aliases pointing to add_fund_profiles.
    # Older callers can continue using add_fund_card,
    # add_fund_charts and add_fund_reports without changing
    # the current report structure.

    alias_method :add_fund_card, :add_fund_profiles
    alias_method :add_fund_charts, :add_fund_profiles
    alias_method :add_fund_reports, :add_fund_profiles

    # ============================================================
    # INDIVIDUAL FUND PROFILE
    # ============================================================

    def add_fund_profile(pdf, fund)
      card_height = 390

      ensure_space(
        pdf,
        card_height + 10
      )

      top = pdf.cursor
      width = pdf.bounds.width

      pdf.fill_color COLORS[:white]

      pdf.fill_rounded_rectangle(
        [0, top],
        width,
        card_height,
        7
      )

      pdf.stroke_color COLORS[:border]
      pdf.line_width = 0.6

      pdf.stroke_rounded_rectangle(
        [0, top],
        width,
        card_height,
        7
      )

      left = 14
      content_width = width - 28
      y = top - 14

      # ----------------------------------------------------------
      # 1. Fund Header Name
      # ----------------------------------------------------------

      pdf.fill_color COLORS[:navy]

      pdf.text_box(
        truncate(
          fund_name(fund),
          72
        ),
        at: [left, y],
        width: content_width,
        height: 16,
        size: 11,
        style: :bold
      )

      y -= 18

      # ----------------------------------------------------------
      # 2. Basic Metadata
      # ----------------------------------------------------------

      isin =
        display_value(
          value_from(
            fund,
            :isin
          )
        )

      currency =
        display_value(
          value_from(
            fund,
            :currency
          )
        )

      nav =
        number(
          value_from(
            fund,
            :nav
          )
        )

      pdf.fill_color COLORS[:muted]

      pdf.text_box(
        "ISIN: #{isin}   |   Currency: #{currency}   |   Latest NAV: #{nav}",
        at: [left, y],
        width: content_width,
        height: 12,
        size: 7.5
      )

      y -= 18

      # ----------------------------------------------------------
      # 3. Current Metrics + Forecast Metrics
      # ----------------------------------------------------------

      add_fund_metrics(
        pdf,
        fund,
        top: y
      )

      # Current metrics = 38px
      # Forecast block begins 46px below.
      # Forecast block height = 58px.
      # Additional spacing = 14px.
      y -= 118

      # ----------------------------------------------------------
      # 4. Market Position Badges
      # ----------------------------------------------------------

      add_fund_position_badges(
        pdf,
        fund,
        top: y
      )

      y -= 44

      pdf.move_cursor_to(y)

      # ----------------------------------------------------------
      # 5. Historical NAV Line Chart
      # ----------------------------------------------------------

      add_fund_chart(
        pdf,
        fund
      )

      pdf.move_down 6

      # ----------------------------------------------------------
      # 6. Qualitative Market Position Summary
      # ----------------------------------------------------------

      add_fund_qualitative_position(
        pdf,
        fund
      )

      pdf.move_cursor_to(
        top - card_height
      )
    end

    # ============================================================
    # FUND METRICS
    #
    # Current metrics:
    #   1D | 1W | 1M | YTD | Since 30 Jun | Volatility |
    #   Drawdown | Opportunity
    #
    # Forecast metrics:
    #   1D Forecast | 30D Forecast | 90D Forecast
    # ============================================================

    def add_fund_metrics(pdf, fund, top:)
      metrics = [
        [
          "1D",
          value_from(
            fund,
            :daily_return
          )
        ],
        [
          "1W",
          value_from(
            fund,
            :weekly_return
          )
        ],
        [
          "1M",
          value_from(
            fund,
            :monthly_return
          )
        ],
        [
          "YTD",
          value_from(
            fund,
            :ytd_return
          )
        ],
        [
          "Since 30 Jun",
          value_from(
            fund,
            :return_since_30_june_2026
          )
        ],
        [
          "Volatility",
          value_from(
            fund,
            :volatility
          )
        ],
        [
          "Drawdown",
          value_from(
            fund,
            :drawdown
          )
        ],
        [
          "Opportunity",
          value_from(
            fund,
            :opportunity_score
          )
        ]
      ]

      width = pdf.bounds.width - 28

      cell_width =
        width /
        metrics.length.to_f

      height = 38

      # ----------------------------------------------------------
      # CURRENT METRICS ROW
      # ----------------------------------------------------------

      metrics.each_with_index do |(label, raw_val), index|
        x =
          14 +
          (index * cell_width)

        pdf.fill_color COLORS[:light]

        pdf.fill_rounded_rectangle(
          [x, top],
          cell_width - 4,
          height,
          4
        )

        pdf.fill_color COLORS[:muted]

        pdf.text_box(
          label,
          at: [x + 2, top - 6],
          width: cell_width - 8,
          height: 9,
          size: 5.5,
          align: :center
        )

        num_val =
          numeric_value(
            raw_val
          )

        display_str =
          label == "Opportunity" ?
            number(raw_val) :
            percentage(raw_val)

        if [
          "1D",
          "1W",
          "1M",
          "YTD",
          "Since 30 Jun"
        ].include?(label)
          pdf.fill_color =
            num_val >= 0 ?
              COLORS[:positive] :
              COLORS[:negative]
        else
          pdf.fill_color COLORS[:navy]
        end

        pdf.text_box(
          display_str,
          at: [x + 2, top - 18],
          width: cell_width - 8,
          height: 12,
          size: 7,
          style: :bold,
          align: :center
        )
      end

      # ----------------------------------------------------------
      # FORECAST ROW
      # ----------------------------------------------------------

      forecast_top = top - 46

      forecast_cards = [
        [
          "1D Forecast",
          forecast_for(
            fund,
            "1d"
          )
        ],
        [
          "30D Forecast",
          forecast_for(
            fund,
            "30d"
          )
        ],
        [
          "90D Forecast",
          forecast_for(
            fund,
            "90d"
          )
        ]
      ]

      forecast_gap = 8

      forecast_width =
        (
          width -
          (forecast_gap * 2)
        ) / 3.0

      forecast_height = 58

      forecast_cards.each_with_index do |(label, forecast), index|
        x =
          14 +
          (
            index *
            (forecast_width + forecast_gap)
          )

        pdf.fill_color COLORS[:lighter]

        pdf.fill_rounded_rectangle(
          [x, forecast_top],
          forecast_width,
          forecast_height,
          5
        )

        pdf.stroke_color COLORS[:border]
        pdf.line_width = 0.4

        pdf.stroke_rounded_rectangle(
          [x, forecast_top],
          forecast_width,
          forecast_height,
          5
        )

        # Label
        pdf.fill_color COLORS[:muted]

        pdf.text_box(
          label,
          at: [x + 7, forecast_top - 7],
          width: forecast_width - 14,
          height: 9,
          size: 6,
          style: :bold
        )

        predicted_nav =
          forecast_predicted_nav(
            forecast,
            fund
          )

        expected_return =
          forecast_expected_return(
            forecast,
            fund
          )

        confidence =
          forecast_confidence_value(
            forecast
          )

        unless forecast.present? &&
               predicted_nav.present?
          pdf.fill_color COLORS[:muted]

          pdf.text_box(
            "N/A",
            at: [x + 7, forecast_top - 24],
            width: forecast_width - 14,
            height: 13,
            size: 8,
            style: :bold,
            align: :center
          )

          pdf.text_box(
            "No forecast available",
            at: [x + 7, forecast_top - 39],
            width: forecast_width - 14,
            height: 9,
            size: 5.5,
            align: :center
          )

          next
        end

        # Predicted NAV
        pdf.fill_color COLORS[:navy]

        pdf.text_box(
          "NAV #{forecast_value(predicted_nav)}",
          at: [x + 7, forecast_top - 23],
          width: forecast_width - 14,
          height: 13,
          size: 8,
          style: :bold,
          align: :center
        )

        # Expected return
        if expected_return.nil?
          return_text = "Return N/A"
          return_color = COLORS[:muted]
        else
          return_text =
            "Return #{forecast_percentage(expected_return)}"

          return_color =
            expected_return >= 0 ?
              COLORS[:positive] :
              COLORS[:negative]
        end

        pdf.fill_color return_color

        pdf.text_box(
          return_text,
          at: [x + 7, forecast_top - 38],
          width: forecast_width - 14,
          height: 9,
          size: 5.8,
          style: :bold,
          align: :center
        )

        # Confidence
        confidence_text =
          if confidence.nil?
            nil
          else
            "Confidence #{format_confidence(confidence)}"
          end

        if confidence_text.present?
          pdf.fill_color COLORS[:slate]

          pdf.text_box(
            confidence_text,
            at: [x + 7, forecast_top - 49],
            width: forecast_width - 14,
            height: 8,
            size: 5.2,
            align: :center
          )
        end
      end
    end

    # ============================================================
    # FORECAST DATA HELPERS
    # ============================================================

    # IMPORTANT:
    #
    # Forecast records in the database use horizons such as:
    #
    #   "1d"
    #   "30d"
    #   "90d"
    #
    # The 1D forecast exists in persisted data, so lookup is now
    # deliberately case-insensitive and does not depend on the
    # dashboard's ForecastReport object.
    #
    # We query Forecast directly through mutual_fund_id and select
    # the newest valid forecast.
    #
    # This also avoids silently losing the 1D forecast because of
    # differences in horizon casing or a stale dashboard wrapper.

    def forecast_for(fund, horizon)
        fund_id =
            value_from(fund, :fund_id) ||
            value_from(fund, :mutual_fund_id) ||
            value_from(fund, :id)

        return nil unless numeric_identifier?(fund_id)

        horizon_value =
            horizon
            .to_s
            .strip
            .downcase

        forecast_records =
            ::Forecast
            .where(mutual_fund_id: fund_id.to_i)
            .where(
                "LOWER(TRIM(horizon)) = ?",
                horizon_value
            )
            .to_a

        return nil if forecast_records.empty?

        report_day =
            if report_date.respond_to?(:to_date)
            report_date.to_date
            else
            Date.parse(report_date.to_s)
            end

        eligible_records =
            forecast_records.select do |forecast|
            target_date =
                value_from(
                forecast,
                :target_date
                )

            next true if target_date.nil?

            target_day =
                if target_date.respond_to?(:to_date)
                target_date.to_date
                else
                Date.parse(target_date.to_s)
                end

            target_day >= report_day
            rescue ArgumentError, TypeError
            false
            end

        records =
            if eligible_records.empty?
            forecast_records
            else
            eligible_records
            end

        records.max_by do |forecast|
            [
            value_from(forecast, :predicted_at) ||
                value_from(forecast, :created_at),
            value_from(forecast, :target_date),
            value_from(forecast, :id)
            ]
        end
    end

    def forecast_predicted_nav(forecast, fund = nil)
      raw =
        value_from(
          forecast,
          :predicted_nav
        )

      return nil if raw.nil?

      numeric = raw.to_f

      current_nav =
        value_from(
          fund,
          :nav
        )

      normalize_forecast_nav(
        numeric,
        current_nav: current_nav
      )
    end

    def normalize_forecast_nav(value, current_nav: nil)
      return nil if value.nil?

      numeric = value.to_f

      return numeric if numeric.zero?

      # Forecast NAVs are normally persisted in native NAV units.
      # Only correct an obvious 100x scaling error when the current
      # NAV is available for comparison.
      if current_nav.present?
        current = current_nav.to_f

        if current.nonzero?
          ratio = numeric / current

          return numeric / 100.0 if ratio >= 50.0
        end
      end

      numeric
    end

    # expected_return_pct is stored as percentage points.
    #
    # Examples:
    #
    #   14.73 => +14.73%
    #   -0.39 => -0.39%
    #   0.37  => +0.37%
    #
    # Therefore DO NOT multiply this value by 100.
    def forecast_expected_return(forecast, fund)
      explicit_return =
        value_from(
          forecast,
          :expected_return_pct
        )

      unless explicit_return.nil?
        numeric = explicit_return.to_f

        # Historical records may occasionally contain fractional
        # values such as 0.1473. If the NAV-derived return strongly
        # indicates that the value is fractional, use the derived
        # percentage-point value.
        derived_return =
          derived_forecast_return(
            forecast,
            fund
          )

        if derived_return.present?
          if numeric.abs < 1.0 &&
             derived_return.abs > numeric.abs * 5.0
            return derived_return
          end
        end

        return numeric
      end

      derived_forecast_return(
        forecast,
        fund
      )
    end

    def derived_forecast_return(forecast, fund)
      predicted_nav =
        value_from(
          forecast,
          :predicted_nav
        )

      current_nav =
        value_from(
          fund,
          :nav
        )

      return nil if predicted_nav.nil?
      return nil if current_nav.nil?
      return nil if current_nav.to_f.zero?

      predicted =
        normalize_forecast_nav(
          predicted_nav.to_f,
          current_nav: current_nav
        )

      current =
        current_nav.to_f

      return nil if predicted.nil?

      (
        (predicted - current) /
        current
      ) * 100.0
    end

    def forecast_confidence_value(forecast)
      value_from(
        forecast,
        :confidence_score
      ) ||
        value_from(
          forecast,
          :confidence
        )
    end

    def format_confidence(value)
      return "N/A" if value.nil?

      numeric = value.to_f

      if numeric <= 1.0
        "#{format('%.0f', numeric * 100)}%"
      else
        "#{format('%.0f', numeric)}%"
      end
    end

    def forecast_percentage(value)
      return "N/A" if value.nil?

      numeric =
        value.to_f

      return "0.00%" if numeric.abs < 0.000001

      # IMPORTANT:
      #
      # expected_return_pct is already expressed in percentage
      # points.
      #
      #   14.73 => +14.73%
      #   -0.39 => -0.39%
      #
      # Do NOT multiply by 100.
      format(
        "%+.2f%%",
        numeric
      )
    end

    def forecast_value(value)
      return "N/A" if value.nil?

      format(
        "%.2f",
        value.to_f
      )
    end

    def forecast_available?(forecast)
      return false if forecast.nil?

      predicted_nav =
        value_from(
          forecast,
          :predicted_nav
        )

      predicted_nav.present?
    end

    # ============================================================
    # MARKET POSITION
    # ============================================================

    def add_fund_position_badges(pdf, fund, top:)
      width = pdf.bounds.width - 28
      gap = 8

      badge_width =
        (width - gap) /
        2.0

      height = 36

      outlook =
        display_value(
          value_from(
            fund,
            :market_outlook
          )
        )

      recommendation =
        display_value(
          value_from(
            fund,
            :recommendation
          )
        )

      [
        [
          "Market Outlook",
          outlook
        ],
        [
          "Recommendation",
          recommendation
        ]
      ].each_with_index do |(label, value), index|
        x =
          14 +
          index *
          (badge_width + gap)

        pdf.fill_color COLORS[:light]

        pdf.fill_rounded_rectangle(
          [x, top],
          badge_width,
          height,
          5
        )

        pdf.fill_color COLORS[:muted]

        pdf.text_box(
          label,
          at: [x + 7, top - 6],
          width: badge_width - 14,
          height: 9,
          size: 6
        )

        pdf.fill_color COLORS[:navy]

        pdf.text_box(
          clean_text(value),
          at: [x + 7, top - 20],
          width: badge_width - 14,
          height: 11,
          size: 8,
          style: :bold
        )
      end
    end

    def add_fund_qualitative_position(pdf, fund)
      outlook =
        display_value(
          value_from(
            fund,
            :market_outlook
          )
        )

      recommendation =
        display_value(
          value_from(
            fund,
            :recommendation
          )
        )

      pdf.fill_color COLORS[:dark]

      pdf.text_box(
        "Current positioning: #{clean_text(outlook)} outlook with a #{clean_text(recommendation)} recommendation.",
        at: [14, pdf.cursor],
        width: pdf.bounds.width - 28,
        height: 18,
        size: 7.5,
        style: :bold
      )

      pdf.move_down 18
    end

    # ============================================================
    # FUND NAV CHART
    # ============================================================

    def add_fund_chart(pdf, fund)
      fund_id =
        value_from(
          fund,
          :fund_id
        ) ||
        value_from(
          fund,
          :id
        )

      unless numeric_identifier?(fund_id)
        render_chart_fallback(
          pdf,
          "NAV history unavailable."
        )

        return
      end

      series =
        Reporting::FundTimeSeriesService.call(
          fund: MutualFund.find(
            fund_id.to_i
          ),
          from_date: BASELINE_DATE,
          to_date: report_date
        )

      nav_history =
        value_from(
          series,
          :nav_history
        )

      nav_history =
        Array(nav_history).select do |point|
          point_date =
            value_from(
              point,
              :date
            )

          point_date.respond_to?(:>=) &&
            point_date >= BASELINE_DATE &&
            point_date <= report_date
        end

      if nav_history.length < 2
        render_chart_fallback(
          pdf,
          "Insufficient NAV history for chart."
        )

        return
      end

      draw_line_chart(
        pdf,
        title:
          "NAV trajectory from #{BASELINE_DATE.strftime('%d %b %Y')} to #{report_date.strftime('%d %b %Y')}",
        points: nav_history
      )
    rescue ActiveRecord::RecordNotFound
      render_chart_fallback(
        pdf,
        "NAV history unavailable."
      )
    rescue StandardError
      render_chart_fallback(
        pdf,
        "NAV history unavailable."
      )
    end

    def render_chart_fallback(pdf, message)
      width = pdf.bounds.width - 28
      height = 95
      top_y = pdf.cursor

      pdf.fill_color COLORS[:lighter]

      pdf.fill_rounded_rectangle(
        [14, top_y],
        width,
        height,
        4
      )

      pdf.stroke_color COLORS[:border]
      pdf.line_width = 0.5

      pdf.stroke_rounded_rectangle(
        [14, top_y],
        width,
        height,
        4
      )

      pdf.fill_color COLORS[:muted]

      pdf.text_box(
        message,
        at: [
          14,
          top_y - (height / 2.0) + 6
        ],
        width: width,
        height: 14,
        size: 7.5,
        align: :center
      )

      pdf.move_down height + 10
    end

    # ============================================================
    # GENERIC CHART BOX
    # ============================================================

    def add_chart_box(pdf, title, height)
      top = pdf.cursor
      width = pdf.bounds.width

      pdf.fill_color COLORS[:white]

      pdf.fill_rounded_rectangle(
        [0, top],
        width,
        height,
        7
      )

      pdf.stroke_color COLORS[:border]
      pdf.line_width = 0.6

      pdf.stroke_rounded_rectangle(
        [0, top],
        width,
        height,
        7
      )

      pdf.fill_color COLORS[:navy]

      pdf.text_box(
        title,
        at: [12, top - 11],
        width: width - 24,
        height: 12,
        size: 8,
        style: :bold
      )

      pdf.move_down 23

      yield

      pdf.move_cursor_to(
        top - height - 10
      )
    end

    # ============================================================
    # BAR CHART
    # ============================================================

    def draw_bar_chart(
      pdf,
      records:,
      value_method:,
      value_formatter:,
      show_value_labels: true
    )
      values =
        records.map do |record|
          raw_value =
            value_from(
              record,
              value_method
            )

          {
            name:
              truncate(
                fund_name(record),
                17
              ),
            value:
              numeric_value(
                raw_value
              )
          }
        end

      return if values.empty?

      width = pdf.bounds.width
      height = 150

      pdf.bounding_box(
        [10, pdf.cursor],
        width: width - 20,
        height: height
      ) do
        left_margin = 42
        right_margin = width - 30
        chart_top = height - 15
        chart_bottom = 30

        chart_width =
          right_margin - left_margin

        chart_height =
          chart_top - chart_bottom

        numeric_values =
          values.map do |item|
            item[:value]
          end

        min_value =
          [
            numeric_values.min,
            0.0
          ].min

        max_value =
          [
            numeric_values.max,
            0.0
          ].max

        value_range =
          [
            max_value - min_value,
            0.01
          ].max

        zero_y =
          chart_bottom +
          (
            (0.0 - min_value) /
            value_range
          ) *
          chart_height

        pdf.stroke_color COLORS[:grid]
        pdf.line_width = 0.45

        5.times do |index|
          ratio = index / 4.0

          y =
            chart_bottom +
            ratio *
            chart_height

          val =
            min_value +
            ratio *
            value_range

          pdf.stroke_horizontal_line(
            left_margin,
            right_margin,
            at: y
          )

          pdf.fill_color COLORS[:muted]

          pdf.text_box(
            value_formatter.call(val),
            at: [0, y + 4],
            width: left_margin - 6,
            height: 9,
            size: 5.5,
            align: :right
          )
        end

        pdf.stroke_color COLORS[:muted]
        pdf.line_width = 0.8

        pdf.stroke_horizontal_line(
          left_margin,
          right_margin,
          at: zero_y
        )

        slot_width =
          chart_width /
          [values.length, 1].max

        bar_width =
          [
            [
              slot_width * 0.58,
              8
            ].max,
            22
          ].min

        values.each_with_index do |item, index|
          value = item[:value]

          center_x =
            left_margin +
            (index + 0.5) *
            slot_width

          x =
            center_x -
            bar_width / 2.0

          value_y =
            chart_bottom +
            (
              (value - min_value) /
              value_range
            ) *
            chart_height

          bar_top =
            [
              value_y,
              zero_y
            ].max

          bar_bottom =
            [
              value_y,
              zero_y
            ].min

          bar_height =
            [
              bar_top - bar_bottom,
              1.5
            ].max

          pdf.fill_color(
            value >= 0 ?
              COLORS[:positive] :
              COLORS[:negative]
          )

          pdf.fill_rounded_rectangle(
            [x, bar_top],
            bar_width,
            bar_height,
            2
          )

          if show_value_labels
            pdf.fill_color COLORS[:dark]

            label_y =
              value >= 0 ?
                bar_top + 8 :
                bar_bottom - 2

            pdf.text_box(
              value_formatter.call(value),
              at: [
                center_x - 22,
                label_y
              ],
              width: 44,
              height: 8,
              size: 5.5,
              style: :bold,
              align: :center
            )
          end

          pdf.fill_color COLORS[:slate]

          pdf.text_box(
            item[:name],
            at: [
              center_x -
                (slot_width / 2.0),
              chart_bottom - 6
            ],
            width: slot_width,
            height: 22,
            size: 5.5,
            align: :center
          )
        end
      end
    end

    # ============================================================
    # SCATTER CHART
    # ============================================================

    def draw_scatter_chart(pdf, records:)
      width = pdf.bounds.width
      height = 175

      pdf.bounding_box(
        [10, pdf.cursor],
        width: width - 20,
        height: height
      ) do
        left_margin = 45
        right_margin = width - 30
        chart_bottom = 28
        chart_top = height - 15

        plot_width =
          right_margin - left_margin

        plot_height =
          chart_top - chart_bottom

        valid_records =
          records.select do |fund|
            numeric_value(
              value_from(
                fund,
                :volatility
              )
            ) != 0.0 ||
              numeric_value(
                value_from(
                  fund,
                  :ytd_return
                )
              ) != 0.0
          end

        return if valid_records.empty?

        x_values =
          valid_records.map do |fund|
            numeric_value(
              value_from(
                fund,
                :volatility
              )
            )
          end

        y_values =
          valid_records.map do |fund|
            numeric_value(
              value_from(
                fund,
                :ytd_return
              )
            )
          end

        min_x =
          [
            x_values.min,
            0.0
          ].min

        max_x =
          [
            x_values.max,
            0.0
          ].max

        min_y =
          [
            y_values.min,
            0.0
          ].min

        max_y =
          [
            y_values.max,
            0.0
          ].max

        x_range =
          [
            max_x - min_x,
            0.01
          ].max

        y_range =
          [
            max_y - min_y,
            0.01
          ].max

        pdf.stroke_color COLORS[:grid]
        pdf.line_width = 0.45

        5.times do |index|
          ratio = index / 4.0

          x =
            left_margin +
            ratio *
            plot_width

          y =
            chart_bottom +
            ratio *
            plot_height

          val_x =
            min_x +
            ratio *
            x_range

          val_y =
            min_y +
            ratio *
            y_range

          pdf.stroke_vertical_line(
            chart_bottom,
            chart_top,
            at: x
          )

          pdf.stroke_horizontal_line(
            left_margin,
            right_margin,
            at: y
          )

          pdf.fill_color COLORS[:muted]

          pdf.text_box(
            percentage(val_y),
            at: [0, y + 4],
            width: left_margin - 6,
            height: 8,
            size: 5.5,
            align: :right
          )

          pdf.text_box(
            percentage(val_x),
            at: [
              x - 20,
              chart_bottom - 5
            ],
            width: 40,
            height: 8,
            size: 5.5,
            align: :center
          )
        end

        if min_y < 0 && max_y > 0
          zero_y =
            chart_bottom +
            (
              (0 - min_y) /
              y_range
            ) *
            plot_height

          pdf.stroke_color COLORS[:muted]
          pdf.line_width = 0.8

          pdf.stroke_horizontal_line(
            left_margin,
            right_margin,
            at: zero_y
          )
        end

        valid_records.each do |fund|
          volatility =
            numeric_value(
              value_from(
                fund,
                :volatility
              )
            )

          ytd =
            numeric_value(
              value_from(
                fund,
                :ytd_return
              )
            )

          x =
            left_margin +
            (
              (volatility - min_x) /
              x_range
            ) *
            plot_width

          y =
            chart_bottom +
            (
              (ytd - min_y) /
              y_range
            ) *
            plot_height

          pdf.fill_color COLORS[:navy]

          pdf.fill_circle(
            [x, y],
            3.5
          )

          label_x =
            if x + 5 >
               right_margin - 80
              right_margin - 80
            else
              x + 5
            end

          label_y =
            [
              [
                y + 4,
                chart_top - 2
              ].min,
              chart_bottom + 10
            ].max

          pdf.fill_color COLORS[:dark]

          pdf.text_box(
            truncate(
              fund_name(fund),
              16
            ),
            at: [
              label_x,
              label_y
            ],
            width: 80,
            height: 10,
            size: 5
          )
        end

        pdf.fill_color COLORS[:muted]

        pdf.text_box(
          "Volatility (Risk)",
          at: [
            left_margin +
              (plot_width / 2.0) -
              40,
            chart_bottom - 16
          ],
          width: 80,
          height: 10,
          size: 6,
          align: :center
        )
      end
    end

    # ============================================================
    # FUND NAV LINE CHART
    # ============================================================

    def draw_line_chart(pdf, title:, points:)
      width = pdf.bounds.width - 28
      height = 95

      start_y = pdf.cursor

      pdf.bounding_box(
        [14, start_y],
        width: width,
        height: height
      ) do
        pdf.fill_color COLORS[:lighter]

        pdf.fill_rounded_rectangle(
          [0, height],
          width,
          height,
          4
        )

        pdf.stroke_color COLORS[:border]
        pdf.line_width = 0.5

        pdf.stroke_rounded_rectangle(
          [0, height],
          width,
          height,
          4
        )

        pdf.fill_color COLORS[:slate]

        pdf.text_box(
          title,
          at: [8, height - 6],
          width: width - 16,
          height: 10,
          size: 6.5,
          style: :bold
        )

        left = 40
        right = width - 12
        bottom = 18
        top = height - 22

        plot_width =
          right - left

        plot_height =
          top - bottom

        nav_values =
          points.map do |pt|
            raw_nav =
              value_from(
                pt,
                :nav
              ) ||
              value_from(
                pt,
                :value
              ) ||
              value_from(
                pt,
                :price
              )

            numeric_value(raw_nav)
          end.compact

        min_y =
          nav_values.min || 0.0

        max_y =
          nav_values.max || 1.0

        y_diff =
          max_y - min_y

        y_range =
          y_diff.zero? ?
            1.0 :
            y_diff

        pdf.stroke_color COLORS[:grid]
        pdf.line_width = 0.45

        3.times do |i|
          ratio = i / 2.0

          y =
            bottom +
            ratio *
            plot_height

          val =
            min_y +
            ratio *
            y_diff

          pdf.stroke_horizontal_line(
            left,
            right,
            at: y
          )

          pdf.fill_color COLORS[:muted]

          pdf.text_box(
            number(val),
            at: [
              0,
              y + 4
            ],
            width: left - 4,
            height: 8,
            size: 5.5,
            align: :right
          )
        end

        pdf.fill_color COLORS[:muted]

        pdf.text_box(
          BASELINE_DATE.strftime(
            "%d %b %Y"
          ),
          at: [
            left,
            bottom - 4
          ],
          width: 70,
          height: 8,
          size: 5.5,
          align: :left
        )

        pdf.text_box(
          report_date.strftime(
            "%d %b %Y"
          ),
          at: [
            right - 70,
            bottom - 4
          ],
          width: 70,
          height: 8,
          size: 5.5,
          align: :right
        )

        total_points =
          points.length

        coords =
          points.each_with_index.map do |pt, i|
            x =
              left +
              (
                i.to_f /
                [total_points - 1, 1].max
              ) *
              plot_width

            raw_nav =
              value_from(
                pt,
                :nav
              ) ||
              value_from(
                pt,
                :value
              ) ||
              value_from(
                pt,
                :price
              )

            val =
              numeric_value(
                raw_nav
              )

            y =
              bottom +
              (
                (
                  val - min_y
                ) /
                y_range
              ) *
              plot_height

            [x, y]
          end

        if coords.size >= 2
          pdf.stroke_color COLORS[:navy]
          pdf.line_width = 1.2

          pdf.stroke do
            pdf.move_to(
              *coords.first
            )

            coords[1..-1].each do |cx, cy|
              pdf.line_to(
                cx,
                cy
              )
            end
          end

          [
            coords.first,
            coords.last
          ].compact.each do |cx, cy|
            pdf.fill_color COLORS[:navy]

            pdf.fill_circle(
              [cx, cy],
              2.0
            )
          end
        end
      end

      pdf.move_cursor_to(
        start_y -
        height -
        8
      )
    end

    # ============================================================
    # TABLE HELPERS
    # ============================================================

    def add_compact_definition_table(pdf, rows)
      pdf.table(
        rows,
        column_widths: [
          130,
          pdf.bounds.width - 130
        ],
        cell_style: {
          padding: [4, 6],
          size: 8,
          borders: [:bottom],
          border_color: COLORS[:grid]
        }
      ) do |t|
        t.columns(0).font_style = :bold
        t.columns(0).text_color = COLORS[:slate]
        t.columns(1).text_color = COLORS[:dark]
      end
    end

    def section_subtitle(pdf, text)
      pdf.fill_color COLORS[:navy]

      pdf.text(
        text,
        size: 10,
        style: :bold
      )

      pdf.move_down 6
    end

    def style_table_header(table)
      table.row(0).background_color =
        COLORS[:navy]

      table.row(0).text_color =
        COLORS[:white]

      table.row(0).font_style =
        :bold

      table.row(0).align =
        :center
    end

    # ============================================================
    # FOOTER
    # ============================================================

    def add_footer(pdf)
      pdf.repeat(:all) do
        pdf.canvas do
          pdf.fill_color COLORS[:muted]

          pdf.draw_text(
            "Mutual Fund Tracker — Executive Report",
            at: [
              PAGE_MARGINS[:left],
              20
            ],
            size: 7
          )
        end
      end

      pdf.number_pages(
        "Page <page> of <total>",
        at: [
          pdf.bounds.right - 100,
          0
        ],
        width: 100,
        align: :right,
        size: 7,
        color: COLORS[:muted]
      )
    end

    # ============================================================
    # LAYOUT HELPERS
    # ============================================================

    def ensure_space(pdf, required_height)
      if pdf.cursor < required_height
        pdf.start_new_page
      end
    end

    # ============================================================
    # DATA HELPERS
    # ============================================================

    def funds
      Array(
        report_value(:funds)
      )
    end

    def report_date
      value_from(
        @report,
        :report_date
      ) || Date.today
    end

    def generated_at
      value_from(
        @report,
        :generated_at
      ) || Time.now.utc
    end

    def report_value(key)
      value_from(
        @report,
        key
      )
    end

    def value_from(object, key)
      return nil if object.nil?

      if object.is_a?(Hash)
        object[key] ||
          object[key.to_s] ||
          object[key.to_sym]
      elsif object.respond_to?(key)
        object.public_send(key)
      end
    end

    def ranking_records(ranking)
      Array(
        value_from(
          ranking,
          :records
        ) || ranking
      )
    end

    def fund_name(record)
      display_value(
        value_from(
          record,
          :name
        ) ||
        value_from(
          record,
          :fund_name
        )
      )
    end

    def display_value(val)
      val.blank? ?
        "N/A" :
        val.to_s
    end

    def numeric_identifier?(val)
      val.to_s.match?(
        /\A\d+\z/
      )
    end

    def numeric_value(val)
      val.to_f
    end

    def integer_value(val)
      val.to_i.to_s
    end

    def number(val)
      return "N/A" if val.nil?

      sprintf(
        "%.2f",
        val.to_f
      )
    end

    def percentage(val)
      return "N/A" if val.nil?

      sprintf(
        "%.2f%%",
        val.to_f * 100
      )
    end

    def truncate(str, max_length)
      return "" if str.nil?

      str.length > max_length ?
        "#{str[0...max_length - 1]}…" :
        str
    end

    def clean_text(text)
      text.to_s.encode(
        "UTF-8",
        invalid: :replace,
        undef: :replace,
        replace: ""
      )
    end
  end
end
