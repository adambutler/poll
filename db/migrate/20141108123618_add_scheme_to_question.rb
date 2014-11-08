class AddSchemeToQuestion < ActiveRecord::Migration
  def up
    add_column :questions, :scheme, :string, default: "web"
    Question.all.each do |question|
      question.scheme = "web"
      question.save!
    end
  end
end
