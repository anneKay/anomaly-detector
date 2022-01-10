class DataSignalValidator
  include ActiveModel::Validations

  attr_reader :threshold, :data

  def initialize(signal_params={})
    @threshold = signal_params[:threshold]
    @data = signal_params[:data]
  end

  validates :threshold, presence: true, numericality: true
  validates :data, length: { minimum: 7 }
  validate :data_is_valid
  
  def data_is_valid
    valid_data = data.kind_of?(Array) && data.all? {|entry| entry.is_a?(Numeric) }
    errors.add(:data, "must be an array of only numbers") unless valid_data
  end
end
