# frozen_string_literal: true

class AnomalyDetector
  attr_reader :data_points, :threshold

  LAG = 5 # size of moving average
  INFLUENCE = 0.5 # influence of previous peak on z-score

  def initialize(signal_params={})
    @data_points = signal_params['data']
    @threshold = signal_params['threshold']
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

      if (data_points[index] - base_data_mean[index-LAG]).abs > threshold * base_data_deviation[index-LAG]
        signals[index] = data_points[index] > base_data_mean[index-LAG] ? 1 : -1
        measured_data[index] = (INFLUENCE * data_points[index]) + ((1-INFLUENCE) * measured_data[prev])
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

end