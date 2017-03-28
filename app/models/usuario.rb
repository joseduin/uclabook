class Usuario
  
  attr_accessor :id, :role_id, :username, :pass, :email, :estatus, :cedula, :nacionalidad

  def initialize(id = 0, role_id = 0, username = '', pass = '', email = '', estatus = 0, cedula = '', nacionalidad = '')
    @id = id
    @role_id = role_id
    @username = username
    @pass = pass
    @email = email
    @estatus = estatus
    @cedula = cedula
    @nacionalidad = nacionalidad
  end
  
end
