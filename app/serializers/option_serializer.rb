class OptionSerializer < ActiveModel::Serializer
  attributes :value, :label

  def value
    object.votes
  end

  def label
    object.title
  end
end
