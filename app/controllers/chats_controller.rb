class ChatsController < ApplicationController
  
  before_filter :authenticate_user!

  layout false

  def create
    if Chat.between(params[:sender_id],params[:recipient_id]).present?
      @chat = Chat.between(params[:sender_id],params[:recipient_id]).first
    else
      @chat = Chat.create!(chat_params)
    end

    render json: { chat_id: @chat.id }
  end

  def show
    @chat = Chat.find(params[:id])
    @reciever = interlocutor(@chat)
    @msgs = @chat.msgs
    @msg = Msg.new
  end

  private
  def chat_params
    params.permit(:sender_id, :recipient_id)
  end

  def interlocutor(chat)
    current_user == chat.recipient ? chat.sender : chat.recipient
  end
  
end
