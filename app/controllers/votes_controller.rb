class VotesController < ApplicationController
  before_filter :set_question, only: [:show]

  def update
    question_id = params[:vote][:question_id]
    vote_id = cookies["vote_#{question_id}"]
    vote = Vote.where({secret: vote_id}).first_or_initialize

    question = Question.where({secret: question_id}).first
    vote.secret = SecureRandom.urlsafe_base64(nil, false) unless vote.secret
    vote.question_id = question.id unless vote.question_id
    vote.option_id = Option.find(params[:vote][:option_id]).id

    Pusher[question_id].trigger("vote", {})

    if vote.save!
      cookies.permanent["vote_#{question.secret}"] = vote.secret

      respond_to do |format|
        format.html { redirect_to "/#{question.secret}" }
        format.json { render json: {}, status: :created }
      end
    end
  end

  def show
  end

  private

  def set_question
    @question = Question.where({secret: params[:secret]}).first
  end

  def question_params
    params.require(:question).permit(:title)
  end
end
