# frozen_string_literal: true

class V1::DataSignalsController < ApplicationController

  def generate_signal_data
    signal_data_params = DataSignalValidator.new(data_signal_params)

    if signal_data_params.valid?
      render json: { signal: anomaly_detector }, status: 200
    else
      render json: signal_data_params.errors, status: 422
    end
  end

private

  def data_signal_params
    params.require(:data_signal).permit(:threshold, data: [])
  end

  def anomaly_detector
    @anomaly_detector ||= AnomalyDetector.new(data_signal_params).call
  end

end
