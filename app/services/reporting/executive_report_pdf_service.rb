
require "prawn"
require "prawn/table"

module Reporting
  class ExecutiveReportPdfService < ApplicationService
    BASELINE_DATE = Date.new(2026, 6, 30)

    FONT_REGULAR = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
    FONT_BOLD = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"

    PAGE_MARGIN = [42, 42, 50, 42]

    def initialize(report: nil)
      @report = report
    end

    def call
      @report ||= Reporting::Dashboard::ExecutiveDashboardService.call

      Prawn::Document.new(
        page_size: "A4",
        margin: PAGE_MARGIN
      ) do |pdf|
        configure_document(pdf)

        add_header(pdf)
        add_executive_snapshot(pdf)
        add_executive_recommendation(pdf)

        pdf.start_new_page

        add_portfolio_performance(pdf)
        add_since_baseline_performance(pdf)

        pdf.start_new_page

        add_risk_analysis(pdf)
        add_rankings(pdf)

        add_fund_reports(pdf)
        add_executive_briefing(pdf)

        add_footer(pdf)
      end.render
    end

    private

    # ============================================================
    # DOCUMENT CONFIGURATION
    # ============================================================

    def configure_document(pdf)
      pdf.font_families.update(
        "DejaVu" => {
          normal: FONT_REGULAR,
          bold: FONT_BOLD
        }
      )

      pdf.font "DejaVu"
      pdf.font_size 9
      pdf.default_leading 3

      pdf.fill_color "243447"
      pdf.stroke_color "D9E2EC"
    end

    # ============================================================
    # HEADER
    # ============================================================

    def add_header(pdf)
      pdf.fill_color "1F3A5F"

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

      pdf.fill_color "52606D"

      pdf.text(
        "As of #{@report.summary.report_date.strftime("%d %B %Y")}",
        size: 11
      )

      pdf.move_down 3

      pdf.text(
        "Generated #{@report.generated_at.strftime("%d %B %Y at %H:%M UTC")}",
        size: 8
      )

      pdf.move_down 15

      pdf.stroke_color "B8C7D9"
      pdf.stroke_horizontal_rule

      pdf.move_down 15

      pdf.fill_color "243447"
    end

    # ============================================================
    # EXECUTIVE SNAPSHOT
    # ============================================================

    def add_executive_snapshot(pdf)
      section_title(pdf, "1. Executive Snapshot")

      insight = @report.portfolio_insight
      summary = @report.summary

      snapshot_cards(
        pdf,
        [
          ["Portfolio Health", insight&.portfolio_health],
          ["Market Sentiment", insight&.market_sentiment],
          ["Portfolio Risk", insight&.portfolio_risk],
          ["Total Funds", summary.total_funds],
          ["Bullish Funds", summary.bullish_count],
          ["Bearish Funds", summary.bearish_count],
          ["Buy", summary.buy_count],
          ["Hold", summary.hold_count],
          ["Sell", summary.sell_count],
          ["Average YTD", percentage(summary.average_ytd_return)],
          ["Average Volatility", percentage(summary.average_volatility)],
          ["Opportunity", number(summary.average_opportunity_score)]
        ]
      )

      pdf.move_down 16

      add_highlight_box(
        pdf,
        "Portfolio Position",
        "Best Performer",
        fund_name(summary.best_performer),
        percentage(summary.best_performer&.ytd_return)
      )

      pdf.move_down 8

      add_highlight_box(
        pdf,
        "Portfolio Position",
        "Worst Performer",
        fund_name(summary.worst_performer),
        percentage(summary.worst_performer&.ytd_return)
      )

      pdf.move_down 8

      add_highlight_box(
        pdf,
        "Risk",
        "Highest Risk",
        fund_name(summary.highest_risk),
        percentage(summary.highest_risk&.volatility)
      )

      pdf.move_down 16
    end

    # ============================================================
    # EXECUTIVE RECOMMENDATION
    # ============================================================

    def add_executive_recommendation(pdf)
      section_title(pdf, "2. Executive Recommendation")

      recommendation =
        @report.portfolio_insight&.executive_recommendation.to_s

      height = 65
      width = pdf.bounds.width
      top = pdf.cursor

      pdf.fill_color "F1F5F9"

      pdf.rounded_rectangle(
        [0, top],
        width,
        height,
        6
      )

      pdf.fill_color "1F3A5F"

      pdf.text_box(
        clean_text(recommendation),
        at: [15, top - 13],
        width: width - 30,
        height: 42,
        size: 11,
        style: :bold,
        leading: 4
      )

      pdf.move_down height + 18
    end

    def add_portfolio_performance(pdf)
      section_title(pdf, "3. Portfolio Performance")

      summary = @report.summary

      add_metric_table(
        pdf,
        [
          ["Average Daily Return", percentage(summary.average_daily_return)],
          ["Average Weekly Return", percentage(summary.average_weekly_return)],
          ["Average Monthly Return", percentage(summary.average_monthly_return)],
          ["Average YTD Return", percentage(summary.average_ytd_return)],
          ["Average Volatility", percentage(summary.average_volatility)],
          ["Average Opportunity Score", number(summary.average_opportunity_score)],
          ["Best Performer", fund_name(summary.best_performer)],
          ["Worst Performer", fund_name(summary.worst_performer)],
          ["Highest Risk", fund_name(summary.highest_risk)],
          ["Lowest Risk", fund_name(summary.lowest_risk)]
        ]
      )

      pdf.move_down 18

      add_portfolio_ytd_chart(pdf)

      pdf.move_down 18

      add_risk_return_chart(pdf)

      pdf.move_down 18

      add_drawdown_chart(pdf)
    end

    # ============================================================
    # JUNE 30 BASELINE PERFORMANCE
    # ============================================================

    def add_since_baseline_performance(pdf)
      section_title(
        pdf,
        "4. Performance Since 30 June 2026"
      )

      pdf.text(
        "Performance compares each fund's NAV on 30 June 2026 with the NAV on the report date.",
        size: 8,
        color: "52606D"
      )

      pdf.move_down 10

      headers = [
        "Fund",
        "30 Jun NAV",
        "Latest NAV",
        "Since 30 Jun",
        "YTD",
        "Volatility",
        "Drawdown"
      ]

      rows = @report.funds.map do |fund|
        baseline_nav = baseline_nav_for(fund)
        latest_nav = fund.nav

        [
          truncate(fund.fund_name, 29),
          number(baseline_nav),
          number(latest_nav),
          percentage(fund.return_since_30_june_2026),
          percentage(fund.ytd_return),
          percentage(fund.volatility),
          percentage(fund.drawdown)
        ]
      end

      pdf.table(
        [headers] + rows,
        header: true,
        column_widths: [
          140,
          62,
          62,
          68,
          55,
          60,
          60
        ],
        cell_style: {
          padding: 5,
          size: 7,
          valign: :center
        }
      ) do |table|
        table.row(0).background_color = "1F3A5F"
        table.row(0).text_color = "FFFFFF"
        table.row(0).font_style = :bold

        table.rows(1..-1).each_with_index do |row, index|
          row.background_color =
            index.even? ? "F8FAFC" : "FFFFFF"
        end
      end

      pdf.move_down 18

      add_since_baseline_chart(pdf)
    end

    # ============================================================
    # FUND PERFORMANCE TABLE
    # ============================================================

    def add_fund_performance_table(pdf)
      section_title(pdf, "Fund Performance Overview")

      headers = [
        "Fund",
        "NAV",
        "1D",
        "1W",
        "1M",
        "YTD",
        "Since 30 Jun",
        "Vol.",
        "DD"
      ]

      rows = @report.funds.map do |fund|
        [
          truncate(fund.fund_name, 25),
          number(fund.nav),
          percentage(fund.daily_return),
          percentage(fund.weekly_return),
          percentage(fund.monthly_return),
          percentage(fund.ytd_return),
          percentage(fund.return_since_30_june_2026),
          percentage(fund.volatility),
          percentage(fund.drawdown)
        ]
      end

      pdf.table(
        [headers] + rows,
        header: true,
        column_widths: [125, 55, 45, 45, 45, 45, 45, 45, 45],
        cell_style: {
          padding: 4,
          size: 6.5,
          valign: :center
        }
      ) do |table|
        table.row(0).background_color = "1F3A5F"
        table.row(0).text_color = "FFFFFF"
        table.row(0).font_style = :bold
      end

      pdf.move_down 18
    end

    # ============================================================
    # RISK ANALYSIS
    # ============================================================

    def add_risk_analysis(pdf)
      section_title(pdf, "5. Risk Analysis")

      rankings = @report.rankings

      add_risk_table(
        pdf,
        "Highest Volatility",
        rankings.highest_risk
      )

      pdf.move_down 14

      add_risk_table(
        pdf,
        "Largest Drawdowns",
        rankings.largest_drawdown
      )

      pdf.move_down 14

      add_risk_table(
        pdf,
        "Lowest Volatility",
        rankings.lowest_risk
      )
    end

    def add_risk_table(pdf, title, records)
      pdf.text(title, size: 10, style: :bold)

      pdf.move_down 6

      data = [
        ["Rank", "Fund", "YTD", "Volatility", "Drawdown"]
      ]

      records.each_with_index do |fund, index|
        data << [
          (index + 1).to_s,
          truncate(ranking_name(fund), 45),
          percentage(fund.ytd_return),
          percentage(fund.volatility),
          percentage(fund.drawdown)
        ]
      end

      pdf.table(
        data,
        header: true,
        column_widths: [35, 250, 65, 75, 75],
        cell_style: {
          padding: 5,
          size: 7
        }
      ) do |table|
        table.row(0).background_color = "334E68"
        table.row(0).text_color = "FFFFFF"
        table.row(0).font_style = :bold
      end
    end

    # ============================================================
    # RANKINGS
    # ============================================================

    def add_rankings(pdf)
      section_title(pdf, "6. Overall Fund Ranking")

      rankings = @report.rankings

      data = [
        ["Rank", "Fund", "ISIN", "YTD", "Vol.", "DD", "Score"]
      ]

      rankings.overall.each do |fund|
        data << [
          fund.rank.to_s,
          truncate(ranking_name(fund), 38),
          fund.isin.to_s,
          percentage(fund.ytd_return),
          percentage(fund.volatility),
          percentage(fund.drawdown),
          fund.portfolio_score.nil? ? "N/A" : number(fund.portfolio_score)
        ]
      end

      pdf.table(
        data,
        header: true,
        column_widths: [35, 165, 80, 55, 55, 55, 55],
        cell_style: {
          padding: 5,
          size: 6.8,
          valign: :center
        }
      ) do |table|
        table.row(0).background_color = "1F3A5F"
        table.row(0).text_color = "FFFFFF"
        table.row(0).font_style = :bold

        table.rows(1..-1).each_with_index do |row, index|
          row.background_color =
            index.even? ? "F8FAFC" : "FFFFFF"
        end
      end

      pdf.move_down 18

      add_fund_performance_table(pdf)
    end

    # ============================================================
    # FUND REPORTS
    # ============================================================

    def add_fund_reports(pdf)
      pdf.start_new_page

      section_title(pdf, "7. Fund-by-Fund Analysis")

      @report.funds.each_with_index do |fund, index|
        add_fund_card(pdf, fund)

        unless index == @report.funds.length - 1
          if pdf.cursor < 190
            pdf.start_new_page
          else
            pdf.move_down 22
          end
        end
      end
    end

    def add_fund_card(pdf, fund)
      card_height = 275
      width = pdf.bounds.width
      top = pdf.cursor

      pdf.fill_color "FFFFFF"

      pdf.rounded_rectangle(
        [0, top],
        width,
        card_height,
        7
      )

      content_left = 14
      content_width = width - 28
      y = top - 14

      pdf.fill_color "1F3A5F"

      pdf.text_box(
        truncate(fund.fund_name, 75),
        at: [content_left, y],
        width: content_width,
        height: 18,
        size: 13,
        style: :bold
      )

      y -= 21

      pdf.fill_color "52606D"

      pdf.text_box(
        "ISIN: #{fund.isin}  |  #{fund.currency}  |  Latest NAV: #{number(fund.nav)}",
        at: [content_left, y],
        width: content_width,
        height: 12,
        size: 7.5
      )

      y -= 21

      add_fund_metrics(
        pdf,
        fund,
        top: y
      )

      y -= 48

      pdf.move_cursor_to(y)

      add_fund_chart(pdf, fund)

      pdf.move_down 8

      pdf.fill_color "243447"

      pdf.text_box(
        "Market Outlook: #{fund.market_outlook}   |   Recommendation: #{fund.recommendation}   |   Portfolio Score: #{number(fund.portfolio_score)}",
        at: [content_left, pdf.cursor],
        width: content_width,
        height: 18,
        size: 7.5,
        style: :bold
      )

      pdf.move_down 18

      pdf.move_down 15
    end

    def add_fund_metrics(pdf, fund, top:)
      metrics = [
        ["1D", percentage(fund.daily_return)],
        ["1W", percentage(fund.weekly_return)],
        ["1M", percentage(fund.monthly_return)],
        ["YTD", percentage(fund.ytd_return)],
        ["Since 30 Jun", percentage(fund.return_since_30_june_2026)],
        ["Volatility", percentage(fund.volatility)],
        ["Drawdown", percentage(fund.drawdown)],
        ["Opportunity", number(fund.opportunity_score)]
      ]

      width = pdf.bounds.width
      cell_width = width / metrics.length
      height = 38

      metrics.each_with_index do |(label, value), index|
        x = index * cell_width

        pdf.fill_color "FFFFFF"

        pdf.rounded_rectangle(
          [x, top],
          cell_width - 4,
          height,
          4
        )

        pdf.fill_color "52606D"

        pdf.text_box(
          label,
          at: [x + 2, top - 7],
          width: cell_width - 8,
          height: 9,
          size: 6,
          align: :center
        )

        pdf.fill_color "1F3A5F"

        pdf.text_box(
          value.to_s,
          at: [x + 2, top - 20],
          width: cell_width - 8,
          height: 12,
          size: 7.5,
          style: :bold,
          align: :center
        )
      end
    end

    # ============================================================
    # EXECUTIVE BRIEFING
    # ============================================================

    def add_executive_briefing(pdf)
      pdf.start_new_page

      section_title(pdf, "8. Executive Briefing")

      briefing = @report.briefing

      text =
        if briefing.respond_to?(:briefing)
          briefing.briefing
        else
          briefing.to_s
        end

      if text.present?
        pdf.fill_color "243447"

        pdf.text(
          clean_markdown(text),
          size: 8.5,
          leading: 4.5
        )
      else
        pdf.text(
          "No executive briefing available.",
          size: 8
        )
      end
    end

    # ============================================================
    # PORTFOLIO YTD CHART
    # ============================================================

    def add_portfolio_ytd_chart(pdf)
      section_title(pdf, "YTD Return by Fund")

      funds = @report.funds

      draw_bar_chart(
        pdf,
        title: "Year-to-date performance",
        records: funds,
        value_method: :ytd_return,
        value_formatter: ->(value) { percentage(value) }
      )
    end

    # ============================================================
    # RISK / RETURN CHART
    # ============================================================

    def add_risk_return_chart(pdf)
      section_title(pdf, "Risk vs Return")

      draw_scatter_chart(
        pdf,
        records: @report.funds
      )
    end

    # ============================================================
    # DRAWDOWN CHART
    # ============================================================

    def add_drawdown_chart(pdf)
      section_title(pdf, "Maximum Drawdown by Fund")

      draw_bar_chart(
        pdf,
        title: "Maximum observed drawdown",
        records: @report.funds,
        value_method: :drawdown,
        value_formatter: ->(value) { percentage(value) }
      )
    end

    # ============================================================
    # SINCE BASELINE CHART
    # ============================================================

    def add_since_baseline_chart(pdf)
      section_title(pdf, "Return Since 30 June 2026")

      draw_bar_chart(
        pdf,
        title: "Change from 30 June 2026 NAV",
        records: @report.funds,
        value_method: :return_since_30_june_2026,
        value_formatter: ->(value) { percentage(value) }
      )
    end

    # ============================================================
    # FUND NAV CHART
    # ============================================================

    def add_fund_chart(pdf, fund)
      series =
        Reporting::FundTimeSeriesService.call(
            fund: MutualFund.find(fund.fund_id),
            from_date: BASELINE_DATE,
            to_date: @report.summary.report_date
        )

      nav_history =
        series[:nav_history].select do |point|
          point[:date] >= BASELINE_DATE &&
            point[:date] <= @report.summary.report_date
        end

      if nav_history.length < 2
        pdf.text(
          "Insufficient NAV history for chart.",
          size: 7,
          color: "7B8794"
        )
        return
      end

      draw_line_chart(
        pdf,
        title: "NAV history: 30 June 2026 to #{@report.summary.report_date.strftime("%d %b %Y")}",
        points: nav_history
      )
    end

    # ============================================================
    # BAR CHART
    # ============================================================

def draw_bar_chart(pdf, title:, records:, value_method:, value_formatter:)
  width = pdf.bounds.width
  height = 185

  values =
    records.map do |record|
      value = record.public_send(value_method)

      {
        name: truncate(record.fund_name, 18),
        value: value.nil? ? 0.0 : value.to_f
      }
    end

  max_abs =
    [values.map { |item| item[:value].abs }.max.to_f, 0.01].max

  top = pdf.cursor

  # White chart container.
  pdf.fill_color "FFFFFF"

  pdf.fill_rectangle(
    [0, top],
    width,
    height
  )

  pdf.stroke_color "D9E2EC"
  pdf.line_width = 0.6

  pdf.stroke_rectangle(
    [0, top],
    width,
    height
  )

  pdf.fill_color "52606D"

  pdf.text_box(
    title,
    at: [10, top - 10],
    width: width - 20,
    height: 12,
    size: 7.5,
    style: :bold
  )

  chart_top = top - 25
  chart_bottom = top - height + 28
  chart_height = chart_top - chart_bottom

  has_positive = values.any? { |item| item[:value] > 0 }
  has_negative = values.any? { |item| item[:value] < 0 }

  zero_y =
    if has_positive && has_negative
      chart_bottom + chart_height / 2.0
    elsif has_positive
      chart_bottom
    else
      chart_top
    end

  bar_area_width = width - 30

  slot_width =
    bar_area_width / [values.length, 1].max

  bar_width =
    [slot_width - 8, 8].max

  values.each_with_index do |item, index|
    value = item[:value]

    x =
      15 +
      index * slot_width +
      4

    bar_height =
      (value.abs / max_abs) *
      (
        if has_positive && has_negative
          chart_height / 2.0
        else
          chart_height
        end
      )

    # Prawn rectangles extend DOWN from their top-left point.
    # Therefore positive bars must start ABOVE zero_y,
    # while negative bars start AT zero_y.
    y =
      if value >= 0
        zero_y + bar_height
      else
        zero_y
      end

    pdf.fill_color(
      value >= 0 ? "3A7D44" : "B94A48"
    )

    pdf.fill_rectangle(
      [x, y],
      bar_width,
      bar_height
    )

    pdf.fill_color "243447"

    label_y =
      if value >= 0
        y + 3
      else
        y - 11
      end

    pdf.text_box(
      value_formatter.call(value),
      at: [x - 4, label_y],
      width: bar_width + 8,
      height: 10,
      size: 5.5,
      align: :center
    )

    pdf.text_box(
      item[:name],
      at: [x - 10, top - height + 24],
      width: bar_width + 20,
      height: 18,
      size: 4.8,
      align: :center
    )
  end

  # Clear zero baseline.
  pdf.stroke_color "94A3B8"
  pdf.line_width = 0.8

  pdf.stroke_horizontal_line(
    10,
    width - 10,
    at: zero_y
  )

  pdf.move_down height + 10
end

    # ============================================================
    # SCATTER CHART
    # ============================================================

    def draw_scatter_chart(pdf, records:)
      width = pdf.bounds.width
      height = 215
      top_y = pdf.cursor

      pdf.fill_color "FFFFFF"
      pdf.rounded_rectangle([0, top_y], width, height, 6)

      left = 45
      right = width - 18
      bottom = top_y - height + 35
      top = top_y - 28

      plot_width = right - left
      plot_height = top - bottom

      x_values = records.map { |fund| fund.volatility.to_f }
      y_values = records.map { |fund| fund.ytd_return.to_f }

      min_x = [x_values.min.to_f, 0].min
      max_x = [x_values.max.to_f, 0].max
      min_y = [y_values.min.to_f, 0].min
      max_y = [y_values.max.to_f, 0].max

      x_range = [max_x - min_x, 0.01].max
      y_range = [max_y - min_y, 0.01].max

      pdf.stroke_color "D9E2EC"

      5.times do |index|
        ratio = index / 4.0
        x = left + ratio * plot_width
        y = bottom + ratio * plot_height

        pdf.stroke_vertical_line(bottom, top, at: x)
        pdf.stroke_horizontal_line(left, right, at: y)
      end

      records.each do |fund|
        x =
          left +
          ((fund.volatility.to_f - min_x) / x_range) *
          plot_width

        y =
          bottom +
          ((fund.ytd_return.to_f - min_y) / y_range) *
          plot_height

        pdf.fill_color "1F3A5F"
        pdf.fill_circle([x, y], 4)

        pdf.fill_color "243447"
        pdf.text_box(
          truncate(fund.fund_name, 17),
          at: [x + 6, y + 3],
          width: 85,
          height: 14,
          size: 4.8
        )
      end

      pdf.fill_color "52606D"

      pdf.text_box(
        "Volatility",
        at: [left + plot_width / 2 - 35, top_y - height + 17],
        width: 70,
        height: 12,
        size: 6,
        align: :center
      )

      pdf.text_box(
        "YTD Return",
        at: [2, bottom + plot_height / 2 + 20],
        width: 65,
        height: 12,
        size: 6
      )

      pdf.move_down height + 10
    end

    # ============================================================
    # LINE CHART
    # ============================================================

    def draw_line_chart(pdf, title:, points:)
      width = pdf.bounds.width
      height = 120
      top_y = pdf.cursor

      pdf.fill_color "FFFFFF"
      pdf.rounded_rectangle([0, top_y], width, height, 5)

      left = 40
      right = width - 12
      bottom = top_y - height + 25
      top = top_y - 23

      plot_width = right - left
      plot_height = top - bottom

      values = points.map { |point| point[:value].to_f }

      min_value = values.min
      max_value = values.max
      range = [max_value - min_value, 0.000001].max

      pdf.fill_color "52606D"

      pdf.text_box(
        title,
        at: [10, top_y - 10],
        width: width - 20,
        height: 10,
        size: 6.5,
        style: :bold
      )

      pdf.stroke_color "E5E7EB"

      4.times do |index|
        ratio = index / 3.0
        y = bottom + ratio * plot_height

        pdf.stroke_horizontal_line(
          left,
          right,
          at: y
        )
      end

      pdf.stroke_color "1F3A5F"

      previous = nil

      points.each_with_index do |point, index|
        denominator = [points.length - 1, 1].max

        x =
          left +
          (index.to_f / denominator) *
          plot_width

        y =
          bottom +
          ((point[:value] - min_value) / range) *
          plot_height

        if previous
          pdf.stroke_line(previous, [x, y])
        end

        previous = [x, y]
      end

      pdf.fill_color "1F3A5F"

      if points.any?
        [points.first, points.last].each_with_index do |point, endpoint_index|
          point_index =
            endpoint_index.zero? ? 0 : points.length - 1

          denominator = [points.length - 1, 1].max

          x =
            left +
            (point_index.to_f / denominator) *
            plot_width

          y =
            bottom +
            ((point[:value] - min_value) / range) *
            plot_height

          pdf.fill_circle([x, y], 2.5)
        end
      end

      pdf.fill_color "52606D"

      pdf.text_box(
        number(min_value),
        at: [5, bottom + 3],
        width: 32,
        height: 10,
        size: 4.8,
        align: :right
      )

      pdf.text_box(
        number(max_value),
        at: [5, top + 3],
        width: 32,
        height: 10,
        size: 4.8,
        align: :right
      )

      if points.any?
        pdf.text_box(
          points.first[:date].strftime("%d Jun"),
          at: [left - 10, top_y - height + 17],
          width: 45,
          height: 10,
          size: 4.8,
          align: :left
        )

        pdf.text_box(
          points.last[:date].strftime("%d %b"),
          at: [right - 35, top_y - height + 17],
          width: 45,
          height: 10,
          size: 4.8,
          align: :right
        )
      end

      pdf.move_down height + 5
    end

    # ============================================================
    # SNAPSHOT CARDS
    # ============================================================

    def snapshot_cards(pdf, cards)
      columns = 4
      gap = 7

      card_width =
        (pdf.bounds.width - (gap * (columns - 1))) / columns

      card_height = 58

      cards.each_slice(columns) do |row|
        row.each_with_index do |(label, value), index|
          x = index * (card_width + gap)

          # Draw the card directly in the current document bounds.
          # Avoid nested bounding_box here because Prawn 2.4.0
          # is strict about bounding_box arguments.

          pdf.fill_color "F1F5F9"

          pdf.rounded_rectangle(
            [x, pdf.cursor],
            card_width,
            card_height,
            5
          )

          pdf.fill_color "52606D"

          pdf.text_box(
            clean_text(label.to_s),
            at: [x, pdf.cursor - 16],
            width: card_width,
            height: 12,
            size: 6,
            align: :center
          )

          pdf.fill_color "1F3A5F"

          pdf.text_box(
            clean_text(value.to_s),
            at: [x, pdf.cursor - 39],
            width: card_width,
            height: 18,
            size: 10,
            style: :bold,
            align: :center
          )
        end

        pdf.move_down card_height + 8
      end
    end

    # ============================================================
    # HIGHLIGHT BOX
    # ============================================================

    def add_highlight_box(pdf, category, label, name, metric)
      height = 52
      width = pdf.bounds.width
      top = pdf.cursor

      pdf.fill_color "FFFFFF"

      pdf.rounded_rectangle(
        [0, top],
        width,
        height,
        5
      )

      pdf.fill_color "7B8794"

      pdf.text_box(
        "#{category}  •  #{label}",
        at: [10, top - 9],
        width: width - 20,
        height: 10,
        size: 6.5,
        style: :bold
      )

      pdf.fill_color "243447"

      pdf.text_box(
        truncate(name.to_s, 65),
        at: [10, top - 25],
        width: width - 20,
        height: 13,
        size: 9,
        style: :bold
      )

      pdf.fill_color "52606D"

      pdf.text_box(
        metric.to_s,
        at: [10, top - 42],
        width: width - 20,
        height: 10,
        size: 7
      )

      pdf.move_down height
    end

    def add_metric_table(pdf, rows)
      data = [["Metric", "Value"]] + rows

      pdf.table(
        data,
        column_widths: [300, pdf.bounds.width - 300],
        header: true,
        cell_style: {
          padding: 6,
          size: 8
        }
      ) do |table|
        table.row(0).background_color = "1F3A5F"
        table.row(0).text_color = "FFFFFF"
        table.row(0).font_style = :bold
      end

      pdf.move_down 15
    end

    # ============================================================
    # SECTION TITLE
    # ============================================================

    def section_title(pdf, title)
      pdf.fill_color "1F3A5F"

      pdf.text(
        title,
        size: 14,
        style: :bold
      )

      pdf.move_down 7

      pdf.stroke_color "D9E2EC"
      pdf.stroke_horizontal_rule

      pdf.move_down 9

      pdf.fill_color "243447"
    end

    # ============================================================
    # FOOTER
    # ============================================================

def add_footer(pdf)
  pdf.repeat(:all) do
    pdf.stroke_color "D9E2EC"
    pdf.line_width = 0.6

    pdf.stroke_horizontal_line(
      0,
      pdf.bounds.width,
      at: -13
    )
  end

  pdf.number_pages(
    "Mutual Fund Tracker  |  Page <page> of <total>",
    at: [0, -30],
    width: pdf.bounds.width,
    height: 12,
    size: 8,
    align: :center
  )
end

    # ============================================================
    # DATA HELPERS
    # ============================================================

    def baseline_nav_for(fund)
      MutualFund
        .find(fund.fund_id)
        .daily_navs
        .where(nav_date: BASELINE_DATE)
        .pick(:nav)
    end

    def fund_name(fund)
      return "N/A" unless fund

      if fund.respond_to?(:fund_name)
        fund.fund_name.to_s
      elsif fund.respond_to?(:name)
        fund.name.to_s
      else
        fund.to_s
      end
    end

    def ranking_name(fund)
      fund_name(fund)
    end

    def percentage(value)
      return "N/A" if value.nil?

      numeric = value.to_f * 100.0

      return "0.00%" if numeric.abs < 0.000001

      format("%+.2f%%", numeric)
    end

    def number(value)
      return "N/A" if value.nil?

      format("%.2f", value.to_f)
    end

    def truncate(value, length)
      text = clean_text(value)

      return text if text.length <= length

      "#{text[0, length - 3]}..."
    end

    def clean_text(text)
      text
        .to_s
        .encode(
          "UTF-8",
          invalid: :replace,
          undef: :replace,
          replace: ""
        )
    end

    def clean_markdown(text)
      cleaned =
        text
          .to_s
          .gsub(/\*\*(.*?)\*\*/, '\1')
          .gsub(/\*(.*?)\*/, '\1')
          .gsub(/^#+\s*/, "")
          .gsub(/^\s*[-*]\s*/, "• ")

      clean_text(cleaned)
    end
  end
end
