class Question < ActiveRecord::Base
  has_many :options
  has_many :votes

  def votes_count
    votes.count
  end
end
