# frozen_string_literal: true

require_relative '../lib/conversion'
require_relative 'support/file_helpers'
require 'csv'
require 'tempfile'
require 'json'
require 'pry'

RSpec.describe Conversion do
  include FileHelpers

  describe 'Conversion#new' do
    it 'should throw an error when given unknown conversion types' do
    end

    it ' should throw an error when passed unexisting files' do
    end
  end

  describe 'Conversion#convert' do
    let(:example_json_file) { File.join(__dir__, 'examples/users.json') }
    let(:example_csv_file) { File.join(__dir__, 'examples/users.csv') }
    let(:tmp_csv_file) { File.join(__dir__, 'tmp/users.csv') }

    before(:each) do
      clean_tmp_files([tmp_csv_file])
    end

    it 'should convert json objects to csv rows where the keys are headers' do
      Conversion.new(
        input: example_json_file,
        from: :json,
        to: :csv,
        output: tmp_csv_file
      ).convert

      result = FileUtils.compare_file(
        File.open(example_csv_file),
        File.open(tmp_csv_file)
      )

      expect(result).to be(true)
    end
  end
end
