# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DataSignals API' do
  let!(:headers) { { "Content-Type": 'application/json' } }

  describe 'POST /v1/data-signals' do

    context 'when valid params are passed in' do
      let(:valid_research_data1) do
        {
          data_signal: {
            data: [1, 1.1, 0.9, 1, 1, 1.2, 2.5, 2.3, 2.4, 1.1, 0.8, 1.2, 1],
            threshold: 3
          }
        }
      end

      let(:valid_research_data2) do
        {
          data_signal: {
            threshold: 3,
            data: [1, 2, 1, 0, 1, 2, 1, 8, 9, 8, 1, 2, 0, 2, 1, 2, 3, 1, 2, 0, 8, 9, 2,
                   0, 3, 0, 2, 1, 2, 3, 8, 10, 2, 1, 2, 3, 0, 1, 2, 1, 2, 7, 6, 9, 1, 2, 0, 1, 2, 1]
          }
        }
      end

      let(:valid_research_data3) do
        {
          data_signal: {
            data: [1, 1.1, 0.9, 1, 1, 1, 1.1, 1.2, 2.5, 2.3, 2.4, 1.1, 0.8, 1.2, 1],
            threshold: 3
          }
        }
      end

      it 'returns the right signal for valid_research_data1' do
        post '/v1/data-signals', params: valid_research_data1.to_json, headers: headers
        output_signal = [0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0]
        result = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(response.body).to_not be_empty
        expect(result['signal'].length).to eq(valid_research_data1[:data_signal][:data].length)
        expect(result['signal']).to eq(output_signal)
      end

      it 'returns the right signal for valid_research_data2' do
        post '/v1/data-signals', params: valid_research_data2.to_json, headers: headers
        output_signal = [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,
                         0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0]
        result = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(response.body).to_not be_empty
        expect(result['signal'].length).to eq(valid_research_data2[:data_signal][:data].length)
        expect(result['signal']).to eq(output_signal)
      end

      it 'returns the right signal for valid_research_data3' do
        post '/v1/data-signals', params: valid_research_data3.to_json, headers: headers
        output_signal = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0]
        result = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(response.body).to_not be_empty
        expect(result['signal'].length).to eq(valid_research_data3[:data_signal][:data].length)
        expect(result['signal']).to eq(output_signal)
      end
    end

    context 'when invalid params are passed in' do
      let(:invalid_research_data_params) do
        {
          data_signal: {
            threshold: 'not a number',
            data: []
          }
        }
      end

      it 'returns the right error response message' do
        post '/v1/data-signals', params: invalid_research_data_params.to_json, headers: headers
        result = JSON.parse(response.body)

        expect(response).to have_http_status(422)
        expect(result['threshold']).to include('is not a number')
        expect(result['data']).to include('is too short (minimum is 7 characters)')
      end
    end
  end

end
