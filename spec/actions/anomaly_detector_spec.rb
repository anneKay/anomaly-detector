# frozen_string_literal: true

require "rails_helper"

RSpec.describe AnomalyDetector do

  describe "AnomalyDetector" do

    let (:valid_signal_params) { { data: [1,1.1,0.9,1,1,1.2,2.5,2.3,2.4,1.1,0.8,1.2,1], threshold: 3} }
    let (:invalid_signal_params) { { data: [] , threshold: 'not a number'} }
     
    context "When called with valid data signal input" do
      subject { AnomalyDetector.new(valid_signal_params).call }

      it "should return the right signal for a data series" do
        output_signal = [0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0]
        expect(subject.length).to eq(output_signal.length)
        expect(subject).to eq(output_signal)
      end
    end
    context "When called with invalid data signal input" do
      subject { AnomalyDetector.new(invalid_signal_params).call }

      it "should return the right signal for a data series" do

        expect(subject).to be(nil)
      end
    end
  end

end
