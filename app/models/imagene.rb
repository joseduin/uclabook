class Imagene
    
  attr_accessor :id, :nombre, :data, :filename, :tipo
  
  def initialize(id = 0, nombre = '', data = '', filename = '', tipo = '')
    @id = id
    @nombre = nombre
    @data = data
    @filename = filename
    @tipo = tipo  
  end
  
end
