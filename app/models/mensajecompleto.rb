class Mensajecompleto
    
  attr_accessor :chat, :perfil

  def initialize(chat = Chat.new, perfil = Perfil.new)
    @chat = chat
    @perfil = perfil
  end
  
end
