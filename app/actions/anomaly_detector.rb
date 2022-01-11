# frozen_string_literal: true

class AnomalyDetector
  attr_reader :data_points, :threshold

  LAG = 5   # size of moving average
  INFLUENCE = 0.5   # influence of previous peak on z-score
  MAXIMUM_PEAK = 1
  MINIMUM_PEAK = -1

  def initialize(signal_params={})
    @data_points = signal_params[:data]
    @threshold = signal_params[:threshold]
  end

  def call
    return nil unless data_points.present?

    data_size = data_points.size
    signals = Array.new(data_size, 0)

    measured_data = data_points.dup
    base_data = measured_data.take(LAG)
    base_data_mean = [mean(base_data)]
    base_data_deviation = [std_deviation(base_data)]

    (LAG..data_size-1).each do |index|
      prev = index - 1

      if (data_points[index] - base_data_mean[index-LAG]).abs > threshold.to_i * base_data_deviation[index-LAG]
        signals[index] = data_points[index] > base_data_mean[index-LAG] ? MAXIMUM_PEAK : MINIMUM_PEAK
        measured_data[index] = get_influence(measured_data, index)
      end

      filtered_base_data = measured_data[index-LAG..prev]
      base_data_mean[(index-LAG)+1] = mean(filtered_base_data)
      base_data_deviation[(index-LAG)+1] = std_deviation(filtered_base_data)
    end
  
    signals
  end

private

  def mean(array)
    array.mean if array.present?
  end

  def std_deviation(array)
    array.stdev if array.present?
  end

  def get_influence(data, index)
    (INFLUENCE * data_points[index]) + ((1-INFLUENCE) * data[index-1])
  end
end
