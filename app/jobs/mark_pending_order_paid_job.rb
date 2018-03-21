class MarkPendingOrderPaidJob < ApplicationJob
  queue_as :mark_pending_order_paid

  def perform(order_name, shop_domain:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    shop.with_shopify_session do
      order = ShopifyAPI::Order.find(:all, params: { name: order_name }).first
      if order.financial_status == 'pending'
        order.capture
      end
    end
  end
end
