# frozen_string_literal: true

class AnomalyDetector
  attr_reader :data_points, :threshold

  LAG = 4.freeze
  INFLUENCE = 0.5.freeze

  def initialize(signal_params={})
    @data_points = signal_params['data']
    @threshold = signal_params['threshold']
  end

  def call
    return nil unless data_points.present?

    size = data_points.size
    signals = Array.new(size, 0)

    measured_data = data_points.dup
    base_data = measured_data.take(LAG)
    base_data_average = [mean(base_data)]
    base_data_deviation = [standard_deviation(base_data)]

    (LAG..size-1).each do |index|
      prev = index - 1

      if (data_points[index] - base_data_average[index-LAG]).abs > threshold * base_data_deviation[index-LAG]
        signals[index] = data_points[index] > base_data_average[index-LAG] ? 1 : -1
        measured_data[index] = (INFLUENCE * data_points[index]) + ((1-INFLUENCE) * measured_data[prev])
      end

      filtered_slice = measured_data[index-LAG..prev]
      base_data_average[(index-LAG)+1] = mean(filtered_slice)
      base_data_deviation[(index-LAG)+1] = standard_deviation(filtered_slice)
    end
    signals
  end

private

  def mean(array)
    array.reduce(&:+) / array.size.to_f
  end

  def standard_deviation(array)
    array_mean = mean(array)
    Math.sqrt(array.reduce(0.0) { |a, b| a.to_f + ((b.to_f - array_mean) ** 2) } / array.size.to_f)
  end

end