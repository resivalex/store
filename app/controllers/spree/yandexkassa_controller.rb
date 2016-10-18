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
    @gateway = @order.available_payment_methods.find { |x| x.id == params[:gateway_id].to_i }

    @yandex_payment_types = @gateway.available_payment_types @order

    unless @order && @gateway
      flash[:error] = I18n.t('invalid_arguments')
      redirect_to :back
      return
    end

    payment = @order.payments
                    .where(payment_method: @gateway)
                    .find(&:can_started_processing?)
    unless payment
      payment = @order.payments.create(amount: @order.total, payment_method: @gateway)
    end
    payment.started_processing!

    # For correct path in payment form we need set mode for OffsitePayments
    OffsitePayments.mode = @gateway.options[:test_mode] ? :test : :production
  end

  def check_order
    logger.debug '=' * 80
    logger.debug params.inspect
    logger.debug '=' * 80
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
    logger.debug '=' * 80
    logger.debug params.inspect
    logger.debug '=' * 80
    @gateway = Spree::Gateway::YandexKassa.current
    if @notification.acknowledge @gateway.options[:password]

      order = Spree::Order.find_by number: @notification.item_id
      if order
        # Find payment for Yandexkassa with status processing and equal amount
        processing_payments = order.payments.where(payment_method: @gateway).select(&:processing?)
        payment = processing_payments.find { |p| p.amount.to_f == @notification.gross }

        unless payment
          payment = order.payments.create(amount: @notification.gross,
                                          payment_method: @gateway) # source: robokassa_transaction)
          payment.started_processing!
        end

        # Complete payment
        payment.complete!
        logger.debug order.attributes
        if order.payment_total?
          # Change order state to paid.
          order.update!
          order.pay!
          order.update!
          order.finalize!
        end
        logger.debug order.attributes
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
