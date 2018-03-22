class Shop < ApplicationRecord
  include ShopifyApp::SessionStorage

  has_many :settings, dependent: :destroy

  before_create :build_associated_settings

  private

    def build_associated_settings
      settings.build([
        { name: 'Mark new pending orders paid.', require_emails: false, webhook_topic: 'orders/create', webhook_action_name: 'mark_new_pending_order_paid' },
        { name: 'Send new order confirmation email', require_emails: true, webhook_topic: 'orders/create', webhook_action_name: 'send_new_order_confirmation_email' }
        ])
    end
end
