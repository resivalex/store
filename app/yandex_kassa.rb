require 'offsite_payments'

module OffsitePayments #:nodoc:
  module Integrations #:nodoc:
    module Yandexkassa
      mattr_accessor :test_url
      self.test_url = 'https://demomoney.yandex.ru/eshop.xml'

      mattr_accessor :production_url
      self.production_url = 'https://money.yandex.ru/eshop.xml'

      def self.service_url
        mode = OffsitePayments.mode

        case mode
        when :production
          production_url
        when :test
          test_url
        else
          raise StandardError, 'Integration mode set to an invalid value: #{mode}'
        end
      end

      def self.success_payment_url
        '/yandexkassa/success_order'
      end

      def self.failed_payment_url
        '/yandexkassa/failed_order'
      end

      def self.notification(post, options = {})
        Notification.new(post, options)
      end

      def self.helper(order, account, options = {})
        Helper.new(order, account, options)
      end

      class Helper < OffsitePayments::Helper
        mapping :account,     'customerNumber'
        mapping :amount,      'sum'
        mapping :order,       'orderNumber'
        mapping :customer,    email: 'cps_email',
                              phone: 'cps_phone'

        mapping :success_url, 'shopSuccessURL'
        mapping :fail_url,    'shopFailURL'

        mapping :scid,        'scid'
        mapping :shop_id,     'shopId'
      end

      class Notification < OffsitePayments::Notification
        def currency
          record = Money::Currency.table.find do |_code, currency|
            currency[:iso_numeric] == shop_sum_currency_paycash
          end
          record.first
        end

        def signature_string
          [
            action,
            order_sum_amount,
            order_sum_currency_paycash,
            order_sum_bank_paycash,
            shop_id,
            invoice_id,
            customer_number
          ]
        end

        def generate_signature(shop_password)
          Digest::MD5.hexdigest((signature_string << shop_password).join(';'))
        end

        def request_datetime
          params['requestDatetime']
        end

        def action
          params['action']
        end

        def md5
          params['md5']
        end

        def shop_id
          params['shopId']
        end

        def shop_article_id
          params['shopArticleId']
        end

        def invoice_id
          params['invoiceId']
        end

        def order_number
          params['orderNumber']
        end

        def customer_number
          params['customerNumber']
        end

        def order_created_datetime
          params['orderCreatedDatetime']
        end

        def order_sum_amount
          params['orderSumAmount']
        end

        def order_sum_currency_paycash
          params['orderSumCurrencyPaycash']
        end

        def order_sum_bank_paycash
          params['orderSumBankPaycash']
        end

        def shop_sum_amount
          params['shopSumAmount']
        end

        def shop_sum_currency_paycash
          params['shopSumCurrencyPaycash']
        end

        def shop_sum_bank_paycash
          params['shopSumBankPaycash']
        end

        def payment_payer_code
          params['paymentPayerCode']
        end

        def payment_type
          params['paymentType']
        end

        def complete?
          case action
          when 'checkOrder'
            'pending'
          when 'paymentAviso'
            'complete'
          else
            'unknown'
          end
        end

        def item_id
          # shop_article_id
          order_number
        end

        # def transaction_id
        #   shop_invoice_id
        # end

        # When was this payment received by the client.
        def received_at
          request_datetime
        end

        def security_key
          md5.to_s.downcase
        end

        # the money amount we received in X.2 decimal.
        def gross
          order_sum_amount.to_f
        end

        def status
          'success'
        end

        def acknowledge(authcode = nil)
          (security_key == generate_signature(authcode))
        end
      end
    end
  end
end
