class Event < ActiveRecord::Base
  acts_as_list

  belongs_to :mercury_image, class_name: 'Mercury::Image'

  # has_attached_file :image, styles: { tile: "300x300#" }
  # validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  default_scope { order(position: :desc) }

  validates :title, presence: true
end