class Decanato
    
  attr_accessor :id, :iniciales, :nombre
  
  def initialize(id = 0, iniciales = '', nombre = '')
    @id = id
    @iniciales = iniciales
    @nombre = nombre
  end
  
end