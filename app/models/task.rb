class Task < ActiveRecord::Base
  attr_accessible :completed_date, :description, :title
end
