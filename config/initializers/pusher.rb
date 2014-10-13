require 'pusher'

Pusher.url = "http://#{ENV['PUSHER_KEY']}:#{ENV['PUSHER_SECRET']}@#{ENV['PUSHER_API_HOST']}/apps/#{ENV['PUSHER_APP_ID']}"
Pusher.logger = Rails.logger

Pusher.host = ENV['PUSHER_API_HOST']
Pusher.port = Integer(ENV['PUSHER_API_PORT'])
