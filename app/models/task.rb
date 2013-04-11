class Task < ActiveRecord::Base
  attr_accessible :completed_at, :description, :title

  def completed?
    completed_at != nil
  end
end
