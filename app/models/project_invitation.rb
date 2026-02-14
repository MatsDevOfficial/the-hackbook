# == Schema Information
#
# Table name: project_invitations
#
#  id            :bigint           not null, primary key
#  email         :string
#  role          :string
#  token         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  invited_by_id :integer
#  project_id    :bigint           not null
#
# Indexes
#
#  index_project_invitations_on_project_id  (project_id)
#  index_project_invitations_on_token       (token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
class ProjectInvitation < ApplicationRecord
  belongs_to :project
  belongs_to :invited_by, class_name: "User"

  attribute :role, :string
  enum :role, { leader: "leader", member: "member" }, default: "member"

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true
  validates :role, presence: true

  before_validation :generate_token, on: :create

  private

  def generate_token
    self.token ||= SecureRandom.hex(20)
  end
end
