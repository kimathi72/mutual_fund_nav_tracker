# frozen_string_literal: true

class ApplicationSerializer
  def self.collection(records, serializer)
    records.map do |record|
      serializer.new(record).as_json
    end
  end
end