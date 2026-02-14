# == Schema Information
#
# Table name: segments
#
#  id               :bigint           not null, primary key
#  content          :text
#  demo_link        :string
#  hours_logged     :integer          default(0)
#  is_unlisted      :boolean          default(FALSE), not null
#  point_multiplier :decimal(5, 2)    default(1.0)
#  repo_link        :string
#  tags             :string           default([]), not null, is an Array
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  project_id       :bigint
#  user_id          :bigint           not null
#
# Indexes
#
#  index_segments_on_project_id  (project_id)
#  index_segments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (user_id => users.id)
#
class Segment < ApplicationRecord
  belongs_to :user
  has_many :ships, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  validates :hours_logged, numericality: { greater_than_or_equal_to: 0 }
  validates :point_multiplier, numericality: { greater_than: 0 }
  validates :is_unlisted, inclusion: { in: [ true, false ] }
  
  validates :demo_link, format: { with: /\Ahttps?:\/\/\S+\z/i, message: "must be a valid URL starting with http:// or https://" }, allow_blank: true
  validates :repo_link, format: { with: /\Ahttps?:\/\/\S+\z/i, message: "must be a valid URL starting with http:// or https://" }, allow_blank: true

  # Ensure tags is always an array
  before_validation :ensure_tags_is_array

  private

  def ensure_tags_is_array
    self.tags ||= []
  end
end
