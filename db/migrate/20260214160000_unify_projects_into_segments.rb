class UnifyProjectsIntoSegments < ActiveRecord::Migration[8.1]
  def change
    # Add project settings to segments
    add_column :segments, :demo_link, :string
    add_column :segments, :repo_link, :string
    add_column :segments, :is_unlisted, :boolean, default: false, null: false
    add_column :segments, :tags, :string, array: true, default: [], null: false
    add_column :segments, :hours_logged, :integer, default: 0
    add_column :segments, :point_multiplier, :decimal, precision: 5, scale: 2, default: 1.0

    # Add segment_id to ships
    add_reference :ships, :segment, foreign_key: true

    # Migration path: 
    # For now, we'll keep the columns but allow ships to belong to segments directly.
    # Data migration would happen here if we had production data.
  end
end
