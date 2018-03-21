class WebhooksController < ActionController::Base
  include ShopifyApp::WebhookVerification

  def mark_new_pending_order_paid
    MarkPendingOrderPaidJob.perform_later(params[:name], shop_domain: shop_domain)
  end

  def send_new_order_confirmation_email
    SendOrderConfirmationEmailJob.perform_later(params[:name], shop_domain: shop_domain)
  end

end
