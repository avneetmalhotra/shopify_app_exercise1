class ApplicationMailer < ActionMailer::Base
  default from: 'new_order_notification@development-store1.myshopify.com'
  layout 'mailer'
end
