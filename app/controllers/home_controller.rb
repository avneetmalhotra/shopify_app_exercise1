class HomeController < ApplicationController
  def index
    @webhooks = ShopifyAPI::Webhook.find(:all)
  end
end
