class AddMetricsToProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :hours_logged, :integer, default: 0
    add_column :projects, :point_multiplier, :decimal, precision: 5, scale: 2, default: 1.0
  end
end
