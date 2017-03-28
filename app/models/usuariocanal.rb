class Usuariocanal
    
  attr_accessor :id, :id_usuario, :id_canal
  
  def initialize(id = 0, id_usuario = 0, id_canal = 0)
    @id = id
    @id_usuario = id_usuario
    @id_canal = id_canal 
  end
  
end
