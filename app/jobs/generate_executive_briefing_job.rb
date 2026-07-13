# frozen_string_literal: true

class GenerateExecutiveBriefingJob < ApplicationJob
  queue_as :reporting

  retry_on StandardError,
           wait: :polynomially_longer,
           attempts: 5

  def perform
    Llm::ExecutiveBriefingService.new.call
  end
end