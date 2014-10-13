require 'pusher'

Pusher.url = "http://#{CONFIG[:pusher]["key"]}:#{CONFIG[:pusher]["secret"]}@api.pusherapp.com/apps/91795"
Pusher.logger = Rails.logger

Pusher.host   = 'localhost'
Pusher.port   = 4567
