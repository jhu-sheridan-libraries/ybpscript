#!/usr/bin/env ruby

require 'marc'
require 'ostruct'

abort "Usage: harrassowitz <MARC_FILE>" unless ARGV.size == 1

MAX_EACH_FILE = 20

reader = MARC::Reader.new ARGV[0], extenal_encoding: 'UTF-8'

records = []
for record in reader
  record.append(MARC::DataField.new('505', ' ' , ' ', ['a', 'TITLE ON ORDER']))
  # reorder the fields
  record.fields.sort! { |a, b| a.tag <=> b.tag }

  # Fix the date
  date = Time.new
  fiscal_year = date.month < 7 ? date.year : date.year + 1 # fiscal year starts at 7/1

  if record['981'] and record['981']['f']
    year = record['981']['f'].chars.last(4).join
    if year != fiscal_year.to_s
      new_f = record['981']['f'].gsub year, fiscal_year.to_s
      record['981'].subfields.each { |sf| sf.value = new_f if sf.code == 'f' }
    end
  end

  if record['980'] and record['980']['g']
    # Copy 980$g to 981$g
    record.append MARC::DataField.new('981', ' ', ' ') unless record['981']
    record['981'].append MARC::Subfield.new('g', record['980']['g'])
    record['980'].subfields.delete_if { |x| x.code == 'g' }
  end

  records << record
end

records.sort! { |a, b| a['245']['a'] <=> b['245']['a'] }
records.each_slice(MAX_EACH_FILE).with_index { |group, index|
  outfile = "#{ARGV[0].gsub(/\.mrc/, '')}_#{index+1}.mrc"
  writer = MARC::Writer.new outfile
  group.each { |record| writer.write record }
  writer.close
}
printf "%-15s %s\n", ARGV[0], records.size
