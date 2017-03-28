class Intere
    
  attr_accessor :id, :nombre, :descripcion, :estatus
  
  def initialize(id = 0, nombre = '', descripcion = '', estatus = 0)
    @id =  id
    @nombre =  nombre
    @descripcion = descripcion
    @estatus = estatus 
  end
  
end
