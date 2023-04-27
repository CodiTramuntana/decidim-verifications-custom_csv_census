# frozen_string_literal: true

require "spec_helper"

module Decidim
  module CustomCsvCensus
    describe CsvData, type: :model do
      include_context "with tmp csv file"

      let(:csv_data) { described_class.new(file, organization) }
      let(:file) { tmp_csv_file }
      let(:organization) { create(:organization) }

      describe "#read" do
        context "with valid data" do
          it "reads the data" do
            csv_data.read
            expect(csv_data.values).not_to be_empty
            expect(csv_data.errors).to be_empty
          end
        end

        context "with invalid data" do
          let(:row2) { ["invalid"] }
          let(:row3) { ["invalid"] }

          it "reads the data" do
            csv_data.read
            expect(csv_data.values).to be_empty
            expect(csv_data.errors).not_to be_empty
          end
        end

        context "with invalid headers" do
          let(:headers) { ["invalid"] }

          it "does not read the data" do
            expect(csv_data).not_to receive(:process_row)
            csv_data.read
          end
        end
      end
    end
  end
end
