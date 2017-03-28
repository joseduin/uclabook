class Comentario
    
  attr_accessor :id, :id_post, :id_usuario, :contenido, :fecha
  
  def initialize(id = 0, id_post = 0, id_usuario = 0, contenido = '', fecha = Time.now)
    @id =  id
    @id_post = id_post
    @id_usuario = id_usuario
    @contenido = contenido
    @fecha = fecha
  end
  
end
