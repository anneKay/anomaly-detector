# frozen_string_literal: true

class V1::DataSignalsController < ApplicationController
  
  def generate_signal_data
    # handle validation first and return appropriate error messages
    render json: anomaly_detector, status: 200
  end

private

  def data_signal_params
    params.require(:data_signal).permit(:threshold, :data => [])
  end

  def anomaly_detector
    @anomaly_detector ||= AnomalyDetector.new(data_signal_params).call
  end
end
