class SendOrderConfirmationEmailJob < ApplicationJob
  queue_as :new_order_notification

  def perform(order_name, shop_domain:)
    shop = Shop.find_by(shopify_domain: shop_domain)
    setting = shop.settings.find_by(name: 'Send new order confirmation email')

    shop.with_shopify_session do
      order = ShopifyAPI::Order.find(:all, params: { name: order_name }).first

      if order.confirmed
        WebhookMailer.order_confirmation_email(shop.id, setting.id).deliver_now
      end
    end
  end

end
