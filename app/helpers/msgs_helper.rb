module MsgsHelper
  def self_or_other(msg)
    msg.user == current_user ? "self" : "other"
  end

  def msg_interlocutor(msg)
    msg.user == msg.chat.sender ? msg.chat.sender : msg.chat.recipient
  end
end
