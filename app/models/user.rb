class User < ApplicationRecord
  has_secure_password
  validates :username, presence: true
  validates :username, uniqueness: { case_sensitive: false }
  validates :username, length: { minimum: 4 }
  validates :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  has_many :learnings
  has_many :tags
  has_many :headings, through: :learnings
  has_many :notes, through: :headings

  def find_learning(learning_id)
    learnings.find_by(id: learning_id)
  end

  def find_headings(learning_id)
    find_learning(learning_id)&.headings
  end

  def find_heading(learning_id, heading_id)
    find_headings(learning_id)&.find_by(id: heading_id)
  end

  def find_notes(learning_id, heading_id)
    find_heading(learning_id, heading_id)&.notes
  end

  def find_note(learning_id, heading_id, note_id)
    find_notes(learning_id, heading_id)&.find_by(id: note_id)
  end

  def find_resources(learning_id, heading_id)
    find_heading(learning_id, heading_id)&.resources
  end

  def find_resource(learning_id, heading_id, resouce_id)
    find_resources(learning_id, heading_id)&.find_by(id: resouce_id)
  end

  def check_username(username)
    User.find_by(username:)
  end
end
