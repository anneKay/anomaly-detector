# frozen_string_literal: true

require "rails_helper"

RSpec.describe DataSignalValidator do

  describe "DataSignalValidator" do

    let (:valid_data_signal_params) { { data: Array.new(7,1), threshold: 3} }
    let (:signal_params_with_invalid_threshold) { { data: Array.new(7,0), threshold: 'not a number'} }
    let (:signal_params_with_invalid_data) { { data: [1,2,1,1,1,'two',1,1,1], threshold: 3} }
    let (:signal_params_with_empty_data) { { data: [], threshold: 3} }
     
    context "When called with valid data input" do
      subject { DataSignalValidator.new(valid_data_signal_params) }

      it "should return true for valid params" do
        expect(subject.valid?).to be true
      end

    end

    context "When called with invalid threshold" do
      subject { DataSignalValidator.new(signal_params_with_invalid_threshold) }

      it "should return false for invalid input" do
        expect(subject.valid?).to be false
      end

      it "should return the right error messages for invalid threshold" do
        subject.validate

        expect(subject.errors[:threshold]).to include("is not a number")
      end
    end

    context "When called with invalid data" do
      subject { DataSignalValidator.new(signal_params_with_invalid_data) }

      it "should return false for invalid input" do
        expect(subject.valid?).to be false
      end

      it "should return the right error messages for invalid data" do
        subject.validate

        expect(subject.errors[:data]).to include("must be an array of only numbers")
      end
    end

    context "When called with empty data" do
      subject { DataSignalValidator.new(signal_params_with_empty_data) }

      it "should return false for invalid input" do
        expect(subject.valid?).to be false
      end

      it "should return the right error messages for invalid data" do
        subject.validate

        expect(subject.errors[:data]).to include("is too short (minimum is 7 characters)")
      end
    end
  end

end
