class Seguidore
    
  attr_accessor :id, :id_usuario, :id_seguidor
      
  def initialize(id = 0, id_usuario = 0, id_seguidor = 0)
    @id =  id
    @id_usuario = id_usuario
    @id_seguidor = id_seguidor     
  end
  
end
