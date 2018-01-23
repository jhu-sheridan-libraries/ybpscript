#!/usr/bin/env ruby

require 'marc'
require 'ostruct'

abort "Usage: ruby yrb.rb <MARC_FILE>" unless ARGV.size == 1

MAX_EACH_FILE = 20

reader = MARC::Reader.new ARGV[0], extenal_encoding: "UTF-8"

accounts = {
  '175009': 'US Approvals',
  '175010': 'US Firms',
  '175059': 'UK Approvals',
  '175060': 'UK Firms',
  '175050': 'Ebooks',
  '175051': 'SAIS Ebooks',
  '175052': 'AFL Ebooks'
}.map {|key, str| [key, OpenStruct.new(name: str, records: [])] }.to_h

total = 0
for record in reader
  # Insert a title if it doesn't have one. It's needed later for sorting
  record.append MARC::DataField.new('245', ' ', ' ', ['a', 'ZZZ No title']) if record['245'].nil? and record['245']['a'].nil?
  # Insert 035
  record.append(MARC::DataField.new('035', ' ', ' ')) if record['035'].nil?
  if record['970'] and record['970']['l']
    record['035'].append MARC::Subfield.new('a', "ybp#{record['970']['l']}")
  else
    puts "Can't find 970$l: ", record
  end
  record.append(MARC::DataField.new('505', ' ' , ' ', ['a', 'TITLE ON ORDER']))
  # reorder the fields
  record.fields.sort! { |a, b| a.tag <=> b.tag }
  if record['970'] and record['970']['x']
    account_id = record['970']['x'].to_sym
    if accounts.has_key? account_id # record['970']['x'].to_s
      accounts[account_id].records << record
    else
      puts 'Invalid account code in 970$x', record['970']['x']
    end
  else
    puts "Can't find 970$x", record
  end
  total += 1
end

abort "Didn't read any record" if total == 0

puts "\nNumber of records read: "
accounts.values.each do | order |
  printf "%-15s %s\n", order.name, order.records.size
end
puts "\nTotal number of records: #{total}"

output_dir = "data/#{Time.now.strftime("%Y-%m-%d")}"
Dir.mkdir output_dir unless File.directory? output_dir

total_written = 0
accounts.values.each do | order |
  if order.records.any?
    order.records.uniq! { |r| r['035']['a'] }
    order.records.sort! { |a, b| a['245']['a'] <=> b['245']['a'] }
    order.records.each_slice(MAX_EACH_FILE).with_index { |group, index|
      writer = MARC::Writer.new "#{output_dir}/#{order.name.downcase.tr(' ', '_')}_#{index+1}.mrc"
      group.each { |record| writer.write record }
      writer.close
    }
    total_written += order.records.size
  end
end

puts "\nNumber of records written: "
accounts.values.each do | order |
  printf "%-15s %s\n", order.name, order.records.size if order.records.any?
end

puts "\nTotal number of records written: #{total_written}"
