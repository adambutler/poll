class QuestionSerializer < ActiveModel::Serializer
  has_many :options
end
