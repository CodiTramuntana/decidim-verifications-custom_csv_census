# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Verifications
    module CustomCsvCensus
      module Admin
        describe CsvForm do
          include_context "with tmp csv file"

          subject { described_class.from_params(params).with_context(context) }

          let(:params) { { file: file } }
          let(:file) { tmp_csv_file }
          let(:context) { { current_organization: create(:organization) } }

          it { is_expected.to be_valid }

          context "without file" do
            let(:file) { nil }

            it { is_expected.to be_invalid }
          end

          context "when file is not a valid csv" do
            before { allow(subject.csv_data).to receive(:read).and_raise(CSV::MalformedCSVError.new(nil, nil)) }

            it { is_expected.to be_invalid }
          end
        end
      end
    end
  end
end
