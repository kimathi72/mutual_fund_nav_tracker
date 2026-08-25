# frozen_string_literal: true

class NavPointSerializer < ApplicationSerializer
  def initialize(point)
    @point = point
  end

  def as_json(*)
    {
      date: point.date,
      nav: point.nav
    }
  end

  private

  attr_reader :point
end