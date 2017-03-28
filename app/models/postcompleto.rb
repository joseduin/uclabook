class Postcompleto
   
   attr_accessor :post, :perfil, :imagen, :fecha, :comentario
   
   def initialize(post = Post.new, perfil = Perfil.new, imagen = Imagene.new, fecha = Time.now, comentario = [])
       @post = post
       @perfil = perfil
       @imagen = imagen
       @fecha = fecha
       @comentario = comentario
   end
    
end