class Event < ActiveRecord::Base
  acts_as_list

  default_scope { order(position: :asc) }

  validates :title, presence: true
end