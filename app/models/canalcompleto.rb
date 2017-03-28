class Canalcompleto
    
  attr_accessor :canal, :imagen, :integrantes
  
  def initialize(canal = Canal.new, imagen = Imagene.new, integrantes = [])
      @canal = canal
      @imagen = imagen
      @integrantes = integrantes
  end
  
end
