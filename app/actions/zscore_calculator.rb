class ZscoreCalculator
  attr_reader :entry, :mean, :standard_deviation

  def initialize(mean, standard_deviation, entry)
    @entry = entry
    @standard_deviation = standard_deviation
    @mean = mean
  end

  def call
    (abs_entry - mean)/standard_deviation
  end

private

  def abs_entry
    entry.abs
  end

end