class Event < ActiveRecord::Base
  acts_as_list

  belongs_to :image, class_name: 'Image'

  default_scope { order(position: :desc) }

  validates :title, presence: true

  def original_image_url
    image.url(:original)
  end
end
