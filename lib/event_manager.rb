require "csv"
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

def clean_zipcode(zip_code)
	zip_code.to_s.rjust(5,'0')[0..4]
end

def legislators_by_zipcode(zip_code)
	legislators = Sunlight::Congress::Legislator.by_zipcode(zip_code)
end

def save_thank_you_letters(id, form_letter)
	Dir.mkdir("output") unless Dir.exists? "output"
	
	filename = "output/thanks_#{id}.html"

	File.open(filename, 'w') do |file|
		file.puts form_letter
	end
end

puts "initialized"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
contents.each do |row|
	id = row[0]	
	name = row[:first_name]
	
	zip_code = clean_zipcode( row[:zipcode] )
	
	legislators = legislators_by_zipcode(zip_code)	

	form_letter = erb_template.result(binding)

	save_thank_you_letters(id, form_letter)
end


=begin
contents = File.read  "event_attendees.csv"
puts contents

lines = File.readlines "event_attendees.csv"
lines.each_with_index do |line, index|
	next if index == 0
	columns = line.split(",")
	name = columns[2]
	puts name
	index
end
=end