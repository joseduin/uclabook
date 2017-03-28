class Canal
    
  attr_accessor :id, :id_creador, :id_interes, :id_imagen, :nombre, :descripcion, :estatus
  
  def initialize(id = 0, id_creador = 0, id_interes = 0, id_imagen = 0, nombre = '', descripcion = '', estatus = 0)
    @id = id 
    @id_creador = id_creador
    @id_interes = id_interes
    @id_imagen = id_imagen
    @nombre = nombre 
    @descripcion = descripcion
    @estatus = estatus
  end
  
end
