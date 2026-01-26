class DashboardsController < ApplicationController
  def show
    # 1. Stats globales 
    @stores_count = Store.count
    @products_count = Product.active.count

    # 2. Les dernières actions
    if Current.user
      @my_recent_reports = Current.user.inventory_reports
                                       .includes(:store)
                                       .order(report_date: :desc)
                                       .limit(5)
    end

    # 3. Accès rapide aux magasins (Triés par ville)
    @stores = Store.ordered_by_city
  end
end
