module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect
      true
    end
  end
end
