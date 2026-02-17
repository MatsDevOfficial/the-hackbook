class ShopController < ApplicationController
  def index
    prizes = Prize.all.order(cost: :asc)
    
    # Calculate total points across all user's projects
    user_projects = current_user.projects
    total_points = user_projects.sum { |p| p.point_balance }
    
    render inertia: "Shop/Index", props: {
      prizes: prizes.as_json,
      user_balance: total_points.to_f.round(2)
    }
  end
end
