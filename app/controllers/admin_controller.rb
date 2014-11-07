class AdminController < ApplicationController
  before_filter :authenticate

  def dashboard
    @questions = Question.all.sort_by { |question| -question.votes.count }.first(10)
  end

  private

  def authenticate
    if Rails.env.production?
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV['ADMIN_USERNAME'] && password == ENV['ADMIN_PASSWORD']
      end
    end
  end
end
