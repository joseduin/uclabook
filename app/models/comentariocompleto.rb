class Comentariocompleto
   
   attr_accessor :comentario, :perfil
   
   def initialize(comentario = Comentario.new, perfil = Perfil.new)
       @comentario = comentario
        @perfil = perfil
   end
    
end