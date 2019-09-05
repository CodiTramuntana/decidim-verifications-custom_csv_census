# frozen_string_literal: true

require "csv"

shared_context "with tmp csv file" do
  let(:headers) { "id_document" }
  let(:row2) { "00000000Z" }
  let(:row3) { "00000000Z" }
  let(:rows) { [headers, row2, row3] }
  let(:tmp_csv_path) { "/tmp/test.csv" }
  let(:tmp_csv_file) { double(path: Pathname.new(tmp_csv_path), original_filename: "test.csv") }

  before(:each) do
    CSV.open(tmp_csv_path, "w") do |csv|
      rows.each do |row|
        csv << row.split(",")
      end
    end
  end

  after(:each) { File.delete(tmp_csv_path) }
end
