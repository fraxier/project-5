class Tag < ApplicationRecord
  validates :name, presence: true
  validates :name, length: { minimum: 2 }
  validates :name, uniqueness: { case_sensitive: false }
  validates :bg_color, presence: true
  validates :font_color, presence: true
  has_and_belongs_to_many :learnings
  belongs_to :user

  before_destroy :can_destroy?, prepend: true

  def self.main_tag_learnings(user_id)
    learnings = Tag.where(user_id:, name: 'Main')&.first&.learnings
    learnings.collect { |learn| { learn:, tags: learn.tags } }
  end

  def self.completed_learnings(user_id)
    learnings = Tag.where(user_id:, name: 'Completed')&.first&.learnings
    learnings.collect { |learn| { learn:, tags: learn.tags } }
  end

  def self.most_common(user_id)
    ActiveRecord::Base.connection.execute(
      "SELECT Tags.id, Tags.bg_color, Tags.font_color, name, COUNT(learning_id) as count FROM
      Tags INNER JOIN Learnings_Tags
      WHERE user_id = #{user_id}
      GROUP BY Tags.id
      ORDER BY count desc
      LIMIT 3"
    )
  end

  def self.summary(user_id)
    ActiveRecord::Base.connection.execute(
      "SELECT name, count, last_updated FROM
      (SELECT Inside.name, Inside.count, Learnings.updated_at as last_updated
      FROM
      (SELECT Tags.id, Tags.name, COUNT(*) as count
      FROM Learnings_Tags INNER JOIN Tags WHERE Tags.user_id=#{user_id}) as Inside
      INNER JOIN Learnings
      ORDER BY Learnings.updated_at DESC)
      LIMIT 1"
    )
  end

  def self.count_learnings_by_tag(user_id)
    Tag.where(user_id:).collect do |tag|
      learnings = tag.learnings
      { name: learnings, count: learnings.count }
    end
  end

  private

  def can_destroy?
    return true if deletable

    errors.add(:base, 'This tag is not deletable')
    throw :abort
  end
end
