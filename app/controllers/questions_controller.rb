class QuestionsController < ApplicationController

  before_filter :set_question, only: [:show, :results]
  after_action :allow_iframe, only: [:show, :results]

  def new
    @question = Question.new
    @option = Option.new
  end

  def create
    @question = Question.new(question_params)
    @question.secret = SecureRandom.urlsafe_base64(nil, false)
    @question.save!

    params[:options].each do |option|
      if option[:title] != ""
        new_option = Option.new
        new_option.title = option[:title]
        new_option.question_id = @question.id
        new_option.save!
      end
    end

    redirect_to "/#{@question.secret}", notice: 'Question was successfully created.'
  end

  def show
    vote_id = cookies["vote_#{@question.secret}"]
    @vote = Vote.where({secret: vote_id}).first_or_initialize
  end

  def results
    @options = @question.options
  end

  private

  def set_question
    @question = Question.where({secret: params[:secret]}).first
  end

  def question_params
    params.require(:question).permit(:title)
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end
end
