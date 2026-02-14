class AddClubFieldsToProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :project_type, :string
    add_column :projects, :club_prizes, :text
    add_column :projects, :github_repo, :string
  end
end
