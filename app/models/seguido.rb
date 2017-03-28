class Seguido
    
  attr_accessor :id, :id_usuario, :id_seguido
      
  def initialize(id = 0, id_usuario = 0, id_seguido = 0)
    @id =  id
    @id_usuario = id_usuario
    @id_seguido = id_seguido     
  end
  
end
