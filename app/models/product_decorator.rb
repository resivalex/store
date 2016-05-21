Spree::Product.class_eval do
  def price_present? currency
    price_in(currency) and !price.nil?
  end
end