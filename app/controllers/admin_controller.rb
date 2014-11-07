class AdminController < ApplicationController
  before_filter :authenticate

  def dashboard
    @questions = Question.all.sort_by { |question| -question.votes.count }.first(10)
  end

  private

  def authenticate
    if Rails.env.production?
      http_basic_authenticate_with name: ENV['ADMIN_USERNAME'], password:  ENV['ADMIN_PASSWORD']
    end
  end
end
