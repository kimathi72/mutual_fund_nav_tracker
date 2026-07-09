# frozen_string_literal: true

module Ml
  class TrainModelService < ApplicationService
    def initialize(client: Ml::Client.new)
      @client = client
    end

    def call
      Rails.logger.info(
        "[TrainModelService] Training model..."
      )

      result = client.train

      Rails.logger.info(result.inspect)

      result
    end

    private

    attr_reader :client
  end
end