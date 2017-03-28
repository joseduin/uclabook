class Perfil
    
  attr_accessor :id, :id_usuario, :username, :fecha_nacimiento, :telefono, :titulo, :ocupacion, :pais, :ciudad, :estado, :sobre_mi, :id_imagen

  def initialize(id = 0, id_usuario = 0, username = '', fecha_nacimiento = Time.now, telefono = '', titulo = '', ocupacion = '', pais = '', ciudad = '', estado = '', sobre_mi = '', id_imagen = 0)
    @id = id
    @id_usuario = id_usuario
    @username = username
    @fecha_nacimiento = fecha_nacimiento
    @telefono = telefono
    @titulo = titulo
    @ocupacion = ocupacion
    @pais = pais
    @ciudad = ciudad
    @estado = estado
    @sobre_mi = sobre_mi
    @id_imagen = id_imagen 
  end

end
