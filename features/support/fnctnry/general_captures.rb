CAPTURE_NUMBER = NUMBER = Transform /^\d+$/ do |number|
  number.to_i
end  

#capture a single word or a quoted string
WORD_OR_QUOTED_STRING = Transform /^((?:\")(?:[^\"]+)(?:\")|(\w+))$/ do | captured_string, extra | 	#"ide hack
	#we need to remove both sorts of quotes if present
	raise 'Barf'
	puts "Chomping"
	captured_string.chomp('"').chomp("'").reverse.chomp("'").chomp('"').reverse
end

WORD = Transform /^\w+$/ do | word |
	word
end

WORDS = Transform /[\w\s]+/ do | words_string |
	words_string
end

QUOTED_STRING = Transform /^(?:\").+(?:\")$/ do | quoted_string | #"ide hack
	quoted_string.chomp('"').chomp("'").reverse.chomp("'").chomp('"').reverse
end

