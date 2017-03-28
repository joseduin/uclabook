class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  BASE_URL = "https://servidor-joseduin.c9users.io"
  
  WEB_URL = "https://uclabook-joseduin.c9users.io"
  WEB_UFT8 = "https%3A%2F%2Fuclabook-joseduin.c9users.io"
  
  protected
    
  def autentificar_usuario?
    if session[:id].nil? || session[:estatus] == 0
      redirect_to root_path
    end
  end
  
  def autentificar_log?
    unless session[:id].nil?
      if session[:estatus].to_i == 0
        redirect_to un_paso_mas_path
      else
        # validar cuando se ponga admin
        redirect_to timelines_path
      end
    end
  end
  
  def get_perfil_propio
    @perfil = Perfil.new
    @imagen_perfil = Imagene.new
    response = RestClient.get("#{BASE_URL}/api/perfils?id_usuario=#{session[:id]}") 
    if (response.code == 200)
      parsed = JSON.parse(response)
      @respuesta = JSON.parse(response) 
      parsed.each do |parse|
        @perfil = Perfil.new(parse['id'].to_i, parse['id_usuario'].to_i, parse['username'], parse['fecha_nacimiento'], parse['telefono'], parse['titulo'], parse['ocupacion'], parse['pais'], parse['ciudad'], parse['estado'], parse['sobre_mi'], parse['id_imagen'].to_i)
       
        # Buscamos el perfil del usuario
        response = RestClient.get("#{BASE_URL}/api/imagenes?id=#{@perfil.id_imagen}") 
        if (response.code == 200) 
          parsed = JSON.parse(response)
          parsed.each do |imagen|
            @imagen_perfil = Imagene.new(imagen['id'].to_i, imagen['nombre'], imagen['data'], imagen['filename'], imagen['tipo'])
          end
        end
      end
    end
    
    buscar_mensajes_pendiente()
  end
  
  def buscar_mensajes_pendiente
    @mensaje_pendiente = []
    response = RestClient.get("#{BASE_URL}/api/chats?id_usuario2=#{session[:id]}") 
    if (response.code == 200) 
      parsed = JSON.parse(response)
      parsed.each do |parse|
        if parse['estatus'].to_i == 1
          @mensaje_pendiente << Chat.new(parse['id'].to_i, parse['id_usuario'].to_i, parse['id_usuario2'].to_i, parse['categoria'].to_i, parse['asunto'], parse['contenido'], parse['estatus'].to_i, parse['fecha'])
        end
      end
    end
  end
  
  def buscar_seguidores(id)
    @seguidores = []
    response = RestClient.get("#{BASE_URL}/api/seguidores?id_usuario=#{id}") 
    if (response.code == 200) 
      parsed = JSON.parse(response)
      parsed.each do |parse|
        @seguidores << parse['id_seguidor'].to_i
      end
    end
  end
  
  def buscar_seguidos(id)
    @seguidos = []
    response = RestClient.get("#{BASE_URL}/api/seguidos?id_usuario=#{id}") 
    if (response.code == 200) 
      parsed = JSON.parse(response)
      parsed.each do |parse|
        @seguidos << parse['id_seguido'].to_i
      end
    end
  end
  
  def buscar_integrantes_canal(id)
    @integrantes_canal = []
    response = RestClient.get("#{BASE_URL}/api/usuariocanals?id_canal=#{id}") 
    if (response.code == 200) 
      parsed = JSON.parse(response)
      parsed.each do |parse|
        @integrantes_canal << parse['id_usuario'].to_i
      end
    end
  end
  
end
