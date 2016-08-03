Spree::Image.class_eval do
  attachment_definitions[:attachment][:styles] = {
    :mini => '48x48>', # thumbs under image
    :small => '320x320>', # images on category view
    :product => '480x480>', # full product image
    :large => '800x600>' # light box image
  }
end
