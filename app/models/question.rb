class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  has_many :answers,
           :dependent => :destroy,
           :order     => 'solution DESC, points_cache DESC'

  validates :group_id, :presence => true
  validates :user_id,  :presence => true
  validates :subject,  :presence => true
  validates :url,      :presence => true, :uniqueness => { :scope => :group_id }

  validate :check_user_permissions

  acts_as_url :subject, :scope => :group_id

  scope :recent, order('created_at DESC')
  scope :answered, where('answers_count != ?', 0)
  scope :unanswered, where('answers_count = ?', 0)

  def to_param
    "#{id}-#{url}"
  end

  def to_s
    "Question ##{id}: #{subject}"
  end

  def participants
    ([user] + answers.map { |a| [a.user] + a.comments.map { |c| c.user } }).flatten.uniq
  end

  def solution
    answers.where(:solution => true).first
  end

  def self.public_questions
    joins(:group).where("groups.privacy = 'public'")
  end

  def self.private_questions(user)
    user_group_ids = user.groups.map(&:id)
    Question.where(:group_id => user_group_ids)
  end

  def self.visible(user)
    # squeel rocks my world, thanks ernie
    Question.joins(:group).where{
      (group.privacy == 'public') |
      (group_id.in(user.groups.map(&:id)))
    }
  end

  private

  def check_user_permissions
    if user && group && group.private?
      errors.add(:user_id, 'is not authorized') unless group.users.include?(user)
    end
  end
end
