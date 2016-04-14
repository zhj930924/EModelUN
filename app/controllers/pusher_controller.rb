class PusherController < ApplicationController
  protect_from_forgery except: :auth_notify
  skip_before_filter :login_required, only: [:auth_notify]
  def auth
    channel    = params[:channel_name]
    socket_id  = params[:socket_id]

    valid = false
    valid = true if channel =~ /private-conversation\.(\d+)/

    if valid
      response = Pusher[channel].authenticate socket_id
      render json: response
    else
      render text: 'Not authorized', status: '403'
    end
  end
end
