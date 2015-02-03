class QuestionsController < ApplicationController

  before_filter :set_question, only: [:show, :results]
  before_filter :check_secret_is_unique, only: [:create]

  def new
    @question = Question.new
    @option = Option.new
  end

  def create
    @question = Question.new(question_params)
    @question.secret = SecureRandom.urlsafe_base64(nil, false) unless @question.secret?
    @question.save!

    params[:options].each do |option|
      if option[:title] != ""
        new_option = Option.new
        new_option.title = option[:title]
        new_option.question_id = @question.id
        new_option.save!
      end
    end

    redirect_to "/#{@question.secret}"
  end

  def show
    vote_id = cookies["vote_#{@question.secret}"]
    @vote = Vote.where({secret: vote_id}).first_or_initialize
  end

  def results
    @options = @question.options
  end

  def check_secret_availability
    render json: { available: !Question.where({secret: params[:secret]}).exists? }
  end

  private

  def set_question
    @question = Question.where({secret: params[:secret]}).first
  end

  def question_params
    params.require(:question).permit(:title, :secret)
  end

  def check_secret_is_unique
    if defined? params[:question][:secret]
      if Question.where({secret: params[:question][:secret]}).exists?
        @question = Question.new(question_params)
        redirect_to :back, notice: 'Sorry that URL is taken'
      end
    end
  end

end
