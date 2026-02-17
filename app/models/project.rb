# == Schema Information
#
# Table name: projects
#
#  id               :bigint           not null, primary key
#  club_prizes      :text
#  demo_link        :string
#  description      :text
#  discarded_at     :datetime
#  github_repo      :string
#  hours_logged     :integer          default(0)
#  is_unlisted      :boolean          default(FALSE), not null
#  name             :string           not null
#  point_multiplier :decimal(5, 2)    default(1.0)
#  project_type     :string
#  repo_link        :string
#  tags             :string           default([]), not null, is an Array
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_projects_on_discarded_at  (discarded_at)
#  index_projects_on_is_unlisted   (is_unlisted)
#  index_projects_on_tags          (tags) USING gin
#  index_projects_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Project < ApplicationRecord
  include Discardable
  include PgSearch::Model

  has_paper_trail

  pg_search_scope :search, against: [ :name, :description ], using: { tsearch: { prefix: true } }

  belongs_to :user
  has_many :ships, dependent: :destroy
  has_many :segments, dependent: :destroy
  has_many :project_memberships, dependent: :destroy
  has_many :members, through: :project_memberships, source: :user
  has_many :project_invitations, dependent: :destroy

  attribute :project_type, :string
  enum :project_type, { personal: "personal", club: "club" }, default: "personal"

  validates :project_type, presence: true

  validates :name, presence: true
  validates :hours_logged, numericality: { greater_than_or_equal_to: 0 }
  validates :point_multiplier, numericality: { greater_than: 0 }
  validates :is_unlisted, inclusion: { in: [ true, false ] }
  validates :demo_link, format: { with: /\Ahttps?:\/\/\S+\z/i, message: "must be a valid URL starting with http:// or https://" }, allow_blank: true
  validates :repo_link, format: :url_or_blank
  validates :github_repo_url, format: :url_or_blank

  scope :listed, -> { where(is_unlisted: false) }

  def available_prizes
    # Mock shop items for now
    [
      { id: "blahaj", name: "Blahaj", cost: 100 },
      { id: "stickers", name: "Hack Club Stickers", cost: 10 },
      { id: "notebook", name: "Hack Club Notebook", cost: 50 }
    ]
  end

  private

  def url_or_blank
    return if repo_link.blank? && github_repo_url.blank?
    
    # Generic URL validation if present
    [repo_link, github_repo_url].each do |url|
      next if url.blank?
      unless url =~ /\Ahttps?:\/\/\S+\z/i
        errors.add(:base, "Link #{url} must be a valid URL starting with http:// or https://")
      end
    end
  end
end
