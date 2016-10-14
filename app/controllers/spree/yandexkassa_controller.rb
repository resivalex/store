class Spree::YandexkassaController < Spree::BaseController
  skip_before_filter :verify_authenticity_token, :only => [:check_order, :payment_aviso]
  before_filter :create_notification, :only => [:check_order, :payment_aviso]

  include OffsitePayments::Integrations
  include Spree::YandexKassaHelper

  # To avoid error undefined local variable or method `cache_key_for_taxons'
  helper 'spree/store'

  helper 'spree/orders'

  def show
    @order = Spree::Order.find_by(number: params[:order_number])
    @order.state = params[:state] if params[:state]
    @gateway = @order.available_payment_methods.detect { |x| x.id == params[:gateway_id].to_i }
    # Available(checked) payments methods for Yandexkassa
    # @payment_methods = @gateway.checked_payment_methods

    @payment_methods = @gateway.available_payment_methods @order

    if @order.blank? || @gateway.blank?
      flash[:error] = I18n.t("invalid_arguments")
      redirect_to :back
    else
      # Find payment for Yandexkassa
      yandex_payments = @order.payment.select { |p| p.payment_method.kind_of? Spree::Gateway::YandexKassa }
      suitable_payments = @order.payments.select(&:can_started_processing?)
      paiment = suitable_payments.first
      if payment.nil?
        payment = @order.payments.create(amount: 0, payment_method: @gateway)
      end
      # Set amount and start processing
      payment.amount = @order.total
      payment.save
      payment.started_processing!

      # For correct path in payment form we need set mode for OffsitePayments
      OffsitePayments.mode = @gateway.options[:test_mode] ? :test : :production
      render :action => :show
    end
  end

  def check_order
    @gateway = Spree::Gateway::YandexKassa.current
    if @notification.acknowledge @gateway.options[:password]
      order = Spree::Order.find_by number: @notification.item_id
      if !order
        @notification.message = Spree.t :order_not_found
      elsif order.total.to_f < @notification.gross
        @notification.message = Spree.t :payment_more_than_order_price
      elsif order.user_id != @notification.customer_id.split.first.to_i
        @notification.message = Spree.t :order_belongs_to_another_user
        # Order with error. Set error code
        @notification.set_response 1
      else
        # Do nothing. Order correct.
        @notification.set_response 0
      end
    end
    render text: @notification.response
  end

  def payment_aviso
    @gateway = Spree::Gateway::YandexKassa.current
    if @notification.acknowledge @gateway.options[:password]

      order = Spree::Order.find_by number: @notification.item_id
      if order
        # TODO надо ли делать транзакцию?
        # robokassa_transaction = Spree::RobokassaTransaction.create

        # Find payment for Yandexkassa with status processing and equal amount
        similar_payments = order.payments.select do |p|
          p.payment_method.kind_of?(Spree::Gateway::YandexKassa) && p.processing? && p.amount.to_f == @notification.gross
        end
        payment = similar_payments.first

        if payment.nil?
          payment = order.payments.create(amount: @notification.gross,
                                          payment_method: @gateway) #,
          # source: robokassa_transaction)
          payment.started_processing!
        end

        # Complete payment
        payment.complete!
        if order.payment_total?
          # Change order state to paid.
          order.update!
          order.pay!
          order.update!
        end
        @notification.set_response 0
      else
        @notification.set_response 1
      end
    end

    render text: @notification.response
  end

  def success_payment
  end

  def failed_payment
  end

  def create_notification
    @notification = Yandexkassa::Notification.new request.raw_post
  end
end
