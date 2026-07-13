# frozen_string_literal: true

class BuildTrainingDatasetJob < ApplicationJob
  queue_as :machine_learning

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 5

  def perform(fund_ids = nil)
    scope =
      if fund_ids.present?
        MutualFund.where(id: fund_ids)
      else
        MutualFund.active
      end

    Ml::BuildTrainingDatasetService.new(
      scope: scope
    ).call

    DatasetExportJob.perform_later(fund_ids)
  end
end