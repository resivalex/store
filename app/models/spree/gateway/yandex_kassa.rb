module Spree
  class Gateway::YandexKassa < Gateway
    preference :shopId, :string
    preference :scid, :string
    preference :password, :string

    # Creating all payment methods
    %w(AC PC MC GP WM SB MP AB MA PB QW KV QP).each { |method| preference "payment_method_#{method}".to_sym, :boolean }

    # Limits for payment methods https://money.yandex.ru/doc.xml?id=527483
    preference :lower_limit_AC, :integer, default: 1
    preference :upper_limit_AC, :integer, default: 250000

    preference :lower_limit_PC, :integer, default: 1
    preference :upper_limit_PC, :integer, default: 60000

    preference :lower_limit_MC, :integer, default: 10
    preference :upper_limit_MC, :integer, default: 14000

    preference :lower_limit_GP, :integer, default: 1
    preference :upper_limit_GP, :integer, default: 15000

    preference :lower_limit_WM, :integer, default: 1
    preference :upper_limit_WM, :integer, default: 60000

    preference :lower_limit_SB, :integer, default: 10
    preference :upper_limit_SB, :integer, default: 10000

    preference :lower_limit_MP, :integer, default: 1
    preference :upper_limit_MP, :integer, default: 15000

    preference :lower_limit_AB, :integer, default: 1
    preference :upper_limit_AB, :integer, default: 60000

    preference :lower_limit_MA, :integer, default: 1
    preference :upper_limit_MA, :integer, default: 250000

    preference :lower_limit_PB, :integer, default: 1
    preference :upper_limit_PB, :integer, default: 60000

    preference :lower_limit_QW, :integer, default: 1
    preference :upper_limit_QW, :integer, default: 250000

    preference :lower_limit_KV, :integer, default: 3000
    preference :upper_limit_KV, :integer, default: 100000

    preference :lower_limit_QP, :integer, default: 100
    preference :upper_limit_QP, :integer, default: 5000

    def provider_class
      self.class
    end

    def self.current
      where(active: true).first
    end

    # @return [Array] of symbols available payment methods
    # depending on order's total price
    # For ex. [:payment_method_AC, :payment_method_MC, :payment_method_PB]
    def available_payment_methods(order)
      amount = order.total
      checked_payment_methods.select { |payment_method| payment_method_in_limit? payment_method, amount }
    end

    private

    # @return [Array] of symbols checked/selected payment methods.
    # For ex. [:payment_method_AC, :payment_method_MC, :payment_method_PB]
    def checked_payment_methods
      defined_preferences.select { |p| p.match /payment_method_/ }.select { |p| options[p] }
    end

    def payment_method_in_limit?(payment_method, amount)
      name = payment_method.to_s.split('_').last

      lower = options["lower_limit_#{name}".to_sym]
      upper = options["upper_limit_#{name}".to_sym]

      amount > lower && amount < upper
    end
    # preference :login, :string
    # preference :password, :string
    # preference :signature, :string
    # preference :server, :string, default: 'sandbox'
    # preference :solution, :string, default: 'Mark'
    # preference :landing_page, :string, default: 'Billing'
    # preference :logourl, :string, default: ''

    # def supports?(source)
    #   true
    # end

    # def provider_class
    #   ::PayPal::SDK::Merchant::API
    # end

    # def provider
    #   ::PayPal::SDK.configure(
    #     :mode      => preferred_server.present? ? preferred_server : "sandbox",
    #     :username  => preferred_login,
    #     :password  => preferred_password,
    #     :signature => preferred_signature)
    #   provider_class.new
    # end

    # def auto_capture?
    #   true
    # end

    # def method_type
    #   'paypal'
    # end

    # def purchase(amount, express_checkout, gateway_options={})
    #   pp_details_request = provider.build_get_express_checkout_details({
    #     :Token => express_checkout.token
    #   })
    #   pp_details_response = provider.get_express_checkout_details(pp_details_request)

    #   pp_request = provider.build_do_express_checkout_payment({
    #     :DoExpressCheckoutPaymentRequestDetails => {
    #       :PaymentAction => "Sale",
    #       :Token => express_checkout.token,
    #       :PayerID => express_checkout.payer_id,
    #       :PaymentDetails => pp_details_response.get_express_checkout_details_response_details.PaymentDetails
    #     }
    #   })

    #   pp_response = provider.do_express_checkout_payment(pp_request)
    #   if pp_response.success?
    #     # We need to store the transaction id for the future.
    #     # This is mainly so we can use it later on to refund the payment if the user wishes.
    #     transaction_id = pp_response.do_express_checkout_payment_response_details.payment_info.first.transaction_id
    #     express_checkout.update_column(:transaction_id, transaction_id)
    #     # This is rather hackish, required for payment/processing handle_response code.
    #     Class.new do
    #       def success?; true; end
    #       def authorization; nil; end
    #     end.new
    #   else
    #     class << pp_response
    #       def to_s
    #         errors.map(&:long_message).join(" ")
    #       end
    #     end
    #     pp_response
    #   end
    # end

    # def refund(payment, amount)
    #   refund_type = payment.amount == amount.to_f ? "Full" : "Partial"
    #   refund_transaction = provider.build_refund_transaction({
    #     :TransactionID => payment.source.transaction_id,
    #     :RefundType => refund_type,
    #     :Amount => {
    #       :currencyID => payment.currency,
    #       :value => amount },
    #     :RefundSource => "any" })
    #   refund_transaction_response = provider.refund_transaction(refund_transaction)
    #   if refund_transaction_response.success?
    #     payment.source.update_attributes({
    #       :refunded_at => Time.now,
    #       :refund_transaction_id => refund_transaction_response.RefundTransactionID,
    #       :state => "refunded",
    #       :refund_type => refund_type
    #     })

    #     payment.class.create!(
    #       :order => payment.order,
    #       :source => payment,
    #       :payment_method => payment.payment_method,
    #       :amount => amount.to_f.abs * -1,
    #       :response_code => refund_transaction_response.RefundTransactionID,
    #       :state => 'completed'
    #     )
    #   end
    #   refund_transaction_response
    # end
  end
end

#   payment.state = 'completed'
#   current_order.state = 'complete'
