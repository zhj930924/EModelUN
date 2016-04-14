class MsgsController < ApplicationController
  before_filter :authenticate_user!

  # def create
  #   @chat = Chat.find(params[:chat_id])
  #   @msg = @chat.msgs.build(msg_params)
  #   @msg.user_id = current_user.id
  #   @msg.save!

  #   @path = chat_path(@chat)
  # end
  
  def create
    @chat = Chat.find(params[:chat_id])
    @msg = @chat.msgs.build(msg_params)
    @msg.user_id = current_user.id
    @msg.save!
    @path = chat_path(@chat)
    model = Msg.create params_model
    json  = model.to_json
    channel = "private-conversation.#{params[:user_id]}"
    Pusher[channel].trigger 'msgs/create', json
  end

  
  private

  def msg_params
    params.require(:msg).permit(:id,:body)
  end
end