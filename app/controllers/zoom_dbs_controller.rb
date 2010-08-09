class ZoomDbsController < ApplicationController
  # everything else is handled by application.rb
  before_filter :login_required, :only => [:list, :index]
  before_filter :set_page_title

  permit "tech_admin of :site"

  active_scaffold :zoom_db do |config|
    list.columns.exclude [:updated_at, :created_at, :zoom_password, :oai_pmh_repository_sets]

    config.columns[:description].options = { :rows => 5 }
    config.columns[:port].options = { :rows => 1 }
    config.columns.exclude :oai_pmh_repository_sets
  end
  
  private
  
    def ssl_required?
      FORCE_HTTPS_ON_RESTRICTED_PAGES || false
    end
    
    # If ssl_allowed? returns true, the SSL requirement is not enforced,
    # so ensure it is not set in this controller.
    def ssl_allowed?
      nil
    end

    def set_page_title
      @title = t('zoom_dbs_controller.title')
    end
    
end
