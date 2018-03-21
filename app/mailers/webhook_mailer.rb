class WebhookMailer < ApplicationMailer

  def order_confirmation_email(shop_id, setting_id)
    @shop = Shop.find_by(id: shop_id)
    emails = Email.where(setting_id: setting_id).pluck(:address)

    mail(subject: 'New Order Notification', to: emails)
  end
end
