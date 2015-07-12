class VotesChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams
    Rails.logger.debug "question:#{data['question_id']}:vote"
    stream_from "question:#{data['question_id']}:vote"
  end

  def unfollow
    stop_all_streams
  end
end
