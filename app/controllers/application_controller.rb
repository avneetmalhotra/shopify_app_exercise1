class ApplicationController < ShopifyApp::AuthenticatedController

  helper_method :current_shop

  def current_shop
    if session[:shopify_domain].present?
      @current_shop ||= Shop.find_by shopify_domain: session[:shopify_domain]
    else
      render_404
    end
  end

  def render_404
    render file: Rails.root.join('public', '404.html'), status: 404 and return
  end
end
