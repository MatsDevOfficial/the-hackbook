class ShopController < ApplicationController
  def index
    prizes = Prize.all.order(cost: :asc)
    
    # Calculate total pages across all user's projects
    user_projects = current_user.projects
    total_pages = user_projects.sum { |p| p.page_balance }
    
    render inertia: "Shop/Index", props: {
      prizes: prizes.as_json,
      user_balance: total_pages.to_f.round(2)
    }
  end
end
