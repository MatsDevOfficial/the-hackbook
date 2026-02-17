class AddProjectEnhancements < ActiveRecord::Migration[8.0]
  def change
    # GitHub integration
    add_column :users, :github_token, :text
    add_column :projects, :github_repo_url, :string
    add_column :projects, :github_repo_name, :string
    
    # Prize selection for club projects
    add_column :projects, :selected_prizes, :text, array: true, default: []
  end
end
