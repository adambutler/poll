class VotesController < ApplicationController
  before_filter :set_question, only: [:show]
  before_filter :set_question_id, only: [:update]
  before_filter :set_vote_id, only: [:update]
  before_filter :throttle, only: [:update]

  def update
    vote = Vote.where({secret: @vote_id}).first_or_initialize

    question = Question.where({secret: @question_id}).first
    vote.secret = SecureRandom.urlsafe_base64(nil, false) unless vote.secret
    vote.question_id = question.id unless vote.question_id
    vote.option_id = Option.find(params[:vote][:option_id]).id

    Pusher[@question_id].trigger("vote", {})

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

  def throttle
    unless Vote.where({secret: @vote_id}).exists?
      client_ip = env["REMOTE_ADDR"]
      agent_hash = Digest::MD5.hexdigest(env["HTTP_USER_AGENT"])
      key = "vote:#{client_ip}-#{agent_hash}"
      count = REDIS.get(key)
      unless count
        REDIS.set(key, 0)
        REDIS.expire(key, 10)
      end

      if count.to_i >= 1
        render nothing: true, status: 429
      else
        REDIS.incr(key)
      end
    end
  end

  private

  def set_question
    @question = Question.where({secret: params[:secret]}).first
  end

  def question_params
    params.require(:question).permit(:title)
  end

  def set_question_id
    @question_id = params[:vote][:question_id]
  end

  def set_vote_id
    @vote_id = cookies["vote_#{@question_id}"]
  end
end
