class Option < ActiveRecord::Base
  has_many :vote
  belongs_to :question

  def votes
    Vote.where({ option_id: self.id }).count
  end
end
