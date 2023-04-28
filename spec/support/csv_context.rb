# frozen_string_literal: true

require "csv"

shared_context "with tmp csv file" do
  let(:headers) { %w(id_document favourite_color birth_date) }
  let(:row2) { ["00000000Z", "yellow", "01/01/2020"] }
  let(:row3) { ["00000000Z", "green", "01/01/2020"] }
  let(:rows) { [headers, row2, row3] }
  let(:tmp_csv_path) { "/tmp/test.csv" }
  let(:tmp_csv_file) { double(path: Pathname.new(tmp_csv_path), original_filename: "test.csv") }

  before do
    CSV.open(tmp_csv_path, "w") do |csv|
      rows.each do |row|
        csv << row
      end
    end
  end

  after { File.delete(tmp_csv_path) }
end
