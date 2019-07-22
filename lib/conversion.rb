# frozen_string_literal: true

require_relative 'extensions/string'
require_relative 'extensions/hash'

# TODO: When multiple files per directory listed below, use mechanism to require_all
require_relative 'converters/json_to_csv_converter'
require_relative 'parsers/json_parser'

class Conversion
  attr_accessor :input
  attr_reader :from, :to, :output
  class UnkownConversionFormatError < StandardError; end
  class UnkownIOPathError < StandardError; end

  CONVERSIONS = %w[json csv].freeze

  def initialize(attributes)
    @from, @to = attributes[:from], attributes[:to]
    check_for_conversions

    @input, @output = attributes[:input], attributes[:output]
    check_for_files
  end

  def convert
    "#{from.upcase}To#{to.upcase}Converter".constantize.new(
      objects: parsed_input,
      file_path: output
    ).convert
  end

  private

  def parsed_input
    @parsed_input ||= "#{from.upcase}Parser".constantize.parse(File.open(input).read)
  end

  def check_for_files
    raise UnkownIOPathError unless [input, output].all? do |path|
      File.exist? path
    end
  end

  def check_for_conversions
    raise UnkownConversionFormatError unless [to, from].all? do |conversion|
      included_conversion?(conversion)
    end
  end

  def included_conversion?(conversion)
    !CONVERSIONS.include? conversion
  end
end
