#!/usr/bin/env ruby

require 'marc'
require 'ostruct'

abort "Usage: casalini <MARC_DIRECTORY>" unless ARGV.size == 1 and File.directory?(ARGV[0])

MAX_EACH_FILE = 20

directory = ARGV[0]

accounts = {
  'MDD000A': 'Italian Firm',
  'MDD0001': 'Non-Italian Firm',
  'MDD000B': 'Italian Lit & Lang Approval',
  'MDD000W': 'Italian Hisotry Approval',
  'MDD000V': 'Spanish and Portuguese Lit & Lang Approval',
  'MDD000F': 'Spanish History Approval',
  'MDD000G': 'Italian and Spanish Art Approval'
}.map {|key, str| [key, OpenStruct.new(name: str, records: [])] }.to_h

def is_firm?(file)
  file.start_with? 'MDD000A' or file.start_with? 'MDD0001'
end

def is_approval?(file)
  ['MDD000B', 'MDD000W', 'MDD000V', 'MDD000F', 'MDD000G'].each do |id|
    return true if file.start_with? id
  end
  return false
end

Dir.foreach(directory) do |file|
  next if file == '.' or file == '..' or file =~ /_\d+\.mrc/
  next puts "File not mapped to any account: #{file}" unless is_firm? file or is_approval? file
  records = []
  reader = MARC::Reader.new File.join(directory, file), extenal_encoding: "UTF-8"
  for record in reader
    record.append MARC::DataField.new('505', ' ' , ' ', ['a', 'TITLE ON ORDER'])
    if is_firm? file
      record['001'].value.gsub!(/^[^\d]*(\d+)/, "it \\1")
    elsif is_approval? file
      record['001'].value = "it #{record['901']['a'].split('/')[-1]}"

      # Change 910 to 971
      record.each_by_tag('910') { |field| field.tag = '971' }

      # Copy 980$g to 970$g
      record.append MARC::DataField.new('970', ' ', ' ', []) unless record['970']
      record['970'].append MARC::Subfield.new('g', record['980']['g'])

      # Copy 990$i to 970$j
      record['970'].append MARC::Subfield.new('j', record['990']['i']) if record['990'] and record['990']['i']

      # Copy 971$c to 970$f
      record['970'].append MARC::Subfield.new('f', record['971']['c']) if record['971'] and record['971']['c']
    end
    # reorder the fields
    record.fields.sort! { |a, b| a.tag <=> b.tag }
    records << record
  end  
  records.sort! { |a, b| a['245']['a'] <=> b['245']['a'] }
  records.each_slice(MAX_EACH_FILE).with_index { |group, index|
    outfile = "#{file.gsub(/\.mrc/, '')}_#{index+1}.mrc"
    writer = MARC::Writer.new File.join(directory, outfile)
    group.each { |record| writer.write record }
    puts index
    writer.close
  }
  printf "%-15s %s\n", file, records.size
end
