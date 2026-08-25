# frozen_string_literal: true

class NavPoint
  attr_reader :date,
              :nav

  def initialize(
    date:,
    nav:
  )
    @date = date
    @nav = nav

    freeze
  end
end