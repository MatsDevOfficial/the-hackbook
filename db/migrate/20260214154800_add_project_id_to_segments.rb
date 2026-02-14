class AddProjectIdToSegments < ActiveRecord::Migration[8.1]
  def change
    add_reference :segments, :project, null: true, foreign_key: true
  end
end
