# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :ssl_required
  

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password


  def ssl_required
    if RAILS_ENV == 'production'
      unless request.ssl?
        redirect_to("https://www.to-cs.org" + request.request_uri) and return false
      end
    end
  end
end
