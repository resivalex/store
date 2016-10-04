require_dependency Spree::Frontend::Engine.root.join('app', 'controllers', 'spree', 'checkout_controller')

Spree::CheckoutController.class_eval do
  before_filter :redirect_to_yandexkassa_form_if_needed, only: [:update, :edit]
  helper 'spree/store'

  private

  # Redirect to yandexkassa
  #
  def redirect_to_yandexkassa_form_if_needed
    return unless (params[:state] == 'payment') || @order.payment?
    payment_method = @order.payments.first.payment_method if @order.payments.any?

    if payment_method.nil? && params[:order].present?
      payment_method = Spree::PaymentMethod.find(
        params[:order][:payments_attributes].first[:payment_method_id]
      )
    end

    if payment_method.is_a? Spree::Gateway::YandexKassa
      redirect_to main_app.yandexkassa_path(
        gateway_id: payment_method.id,
        order_number: @order.number
      )
    end
  end
end
