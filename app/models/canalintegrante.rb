class Canalintegrante
    
  attr_accessor :perfil, :imagen
  
  def initialize(perfil = Perfil.new, imagen = Imagene.new)
      @perfil = perfil
      @imagen = imagen
  end
  
end
