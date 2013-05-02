# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'bcrypt'

def doing(activity, &block)
  @world = Object.new

  print "#{activity}..."
  @world.instance_eval &block
  puts "DONE"
end

doing "Removing Data" do
  User.delete_all
  Task.delete_all
  SessionRecord.delete_all
end

doing "Adding Users"  do
  @ben = User.new({name:'', email_address:'bendavies@he3.com.au'})
  @ben.password = 'hi'
  @ben.save!
end