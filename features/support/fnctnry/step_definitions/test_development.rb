#This file contains step definitions useful in generic test development

Then /^this test should fail$/ do
	dev_warning
  fail 'This test intentionally failed'
end

Then /^I wait for (#{NUMBER}) seconds$/ do | seconds |
	dev_warning
	puts "Recieved #{seconds} of type #{seconds.class.name}"
	sleep(seconds.to_i)
end

def dev_warning
	warning "You are using a step from the test development definitions"
end