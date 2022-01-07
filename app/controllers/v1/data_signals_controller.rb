class V1::DataSignalsController < ApplicationController
  
  def generate_signal_data

    render json: true, status: 200
  end

private

  def signal_params
    params.permit(:data, :threshold)
  end
end
