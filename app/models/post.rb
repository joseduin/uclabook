class Post
    
  attr_accessor :id, :tipo, :id_usuario, :id_canal, :titulo, :contenido, :fecha, :estatus
  
  def initialize(id = 0, tipo = 0, id_usuario = 0, id_canal = 0, titulo = '', contenido = '', fecha = Time.now, estatus = 0)
    @id = id
    @tipo = tipo
    @id_usuario = id_usuario
    @id_canal = id_canal
    @titulo = titulo
    @contenido = contenido
    @fecha = fecha
    @estatus = estatus
  end
  
end
