class CreateProjectInvitations < ActiveRecord::Migration[8.1]
  def change
    create_table :project_invitations do |t|
      t.references :project, null: false, foreign_key: true
      t.string :email
      t.string :token
      t.string :role
      t.integer :invited_by_id

      t.timestamps
    end
    add_index :project_invitations, :token, unique: true
  end
end
