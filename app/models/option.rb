class Option < ActiveRecord::Base
  has_many :vote
  belongs_to :question
  after_create :generate_secret

  def votes
    Vote.where({ option_id: self.id }).count
  end

  def to_param
    secret
  end

  def generate_secret
    begin
      self[:secret] = rand(36**6).to_s(36)
    end while Option.exists?(:secret => self[:secret])
    save!
  end

end
