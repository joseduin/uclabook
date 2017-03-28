class Egresado
    
  attr_accessor :id, :nacionalidad, :cedula, :nombre, :apellido, :email, :fecha_egreso, :carrera, :decanato
    
  def initialize(id = 0, nacionalidad = '', cedula = 0, nombre = '', apellido = '', email = '', fecha_egreso = Time.now, carrera = '', decanato = '')
    @id = id
    @nacionalidad = nacionalidad
    @cedula = cedula
    @nombre = nombre
    @apellido = apellido
    @email = email
    @fecha_egreso = fecha_egreso
    @carrera = carrera
    @decanato = decanato
  end
  
end
