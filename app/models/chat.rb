class Chat
    
  attr_accessor :id, :id_usuario, :id_usuario2, :categoria, :asunto, :contenido, :estatus, :fecha

  def initialize(id = 0, id_usuario = 0, id_usuario2 = 0, categoria = 0, asunto = '', contenido = '', estatus = 0, fecha = Time.now)
    @id = id
    @id_usuario = id_usuario
    @id_usuario2 =  id_usuario2
    @categoria = categoria
    @asunto =  asunto
    @contenido =  contenido
    @estatus =  estatus
    @fecha = fecha
  end
  
end
