class TimelinesController < ApplicationController
    before_action :autentificar_usuario?, only: [:index, :galeria, :publico]
    before_action :get_perfil_propio, only: [:index, :galeria, :publico]

    def index
      @web_url = WEB_URL
      @web_uft8 = WEB_UFT8
      @postes = []
      posts = Post.new
      response = RestClient.get("#{BASE_URL}/api/seguidos?id_usuario=#{session[:id]}") 
      if (response.code == 200) 
        parsed = JSON.parse(response)
        parsed.each do |pars|

          buscar_posts(pars['id_seguido'])
          
        end
      end
      buscar_posts(session[:id])
      @postes.sort! { |a,b| Time.parse(b.fecha) <=> Time.parse(a.fecha) }
    end
    
    def publico
      @web_url = WEB_URL
      @web_uft8 = WEB_UFT8
      @postes = []
      posts = Post.new
      response = RestClient.get("#{BASE_URL}/api/posts?order=created_at:desc") 
      if (response.code == 200) 
        parsed = JSON.parse(response)
        parsed.each do |parse|
          posts = Post.new(parse['id'].to_i, parse['tipo'].to_i, parse['id_usuario'].to_i, parse['id_canal'].to_i, parse['titulo'], parse['contenido'], parse['fecha'], parse['estatus'])          
              
          perfil = Perfil.new
          response = RestClient.get("#{BASE_URL}/api/perfils?id_usuario=#{parse['id_usuario']}") 
          if (response.code == 200) 
            parsed = JSON.parse(response)
              parsed.each do |user|
              perfil = Perfil.new(user['id'].to_i, user['id_usuario'].to_i, user['username'], user['fecha_nacimiento'], user['telefono'], user['titulo'], user['ocupacion'], user['pais'], user['ciudad'], user['estado'], user['sobre_mi'], user['id_imagen'].to_i)
            end
          end
              
          imagen = Imagene.new
          response = RestClient.get("#{BASE_URL}/api/imagenes?id=#{perfil.id_imagen}") 
          if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |imag|
              imagen = Imagene.new(imag['id'].to_i, imag['nombre'], imag['data'], imag['filename'], imag['tipo'])
            end
          end
              
          postcompleto = Postcompleto.new
          postcompleto.perfil = perfil
          postcompleto.post = posts
          postcompleto.imagen = imagen
          postcompleto.comentario = buscar_comentarios(posts.id)
          @postes << postcompleto
            
        end  
      end
    end

    def calendario
        
    end
    
    def contactos
        
    end
    
    def galeria
      buscar_fotos(params[:id])  
    end
    
    def notifications
        
    end
    
    def poste
        
    end
    
    private
    
    def buscar_fotos(id)
      @imagenes = []
      image = Imagene.new
      response = RestClient.get("#{BASE_URL}/api/galerias?id_usuario=#{id}") 
      if (response.code == 200)
        parsed = JSON.parse(response)
        parsed.each do |parse|
          
          # Buscamos el perfil del usuario
          response = RestClient.get("#{BASE_URL}/api/imagenes?id=#{parse['id_imagen']}") 
          if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |imagen|
              image = Imagene.new(imagen['id'].to_i, imagen['nombre'], imagen['data'], imagen['filename'], imagen['tipo'])
            end
          end
          
          @imagenes << image
        end
      end
    end
    
    def buscar_posts(id)
      response = RestClient.get("#{BASE_URL}/api/posts?id_usuario=#{id}") 
      if (response.code == 200) 
        parsed = JSON.parse(response)
        parsed.each do |parse|
          posts = Post.new(parse['id'].to_i, parse['tipo'].to_i, parse['id_usuario'].to_i, parse['id_canal'].to_i, parse['titulo'], parse['contenido'], parse['fecha'], parse['estatus'])          
            
          perfil = Perfil.new
          response = RestClient.get("#{BASE_URL}/api/perfils?id_usuario=#{posts.id_usuario}") 
          if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |user|
                perfil = Perfil.new(user['id'].to_i, user['id_usuario'].to_i, user['username'], user['fecha_nacimiento'], user['telefono'], user['titulo'], user['ocupacion'], user['pais'], user['ciudad'], user['estado'], user['sobre_mi'], user['id_imagen'].to_i)
            end
          end
          
          imagen = Imagene.new
          response = RestClient.get("#{BASE_URL}/api/imagenes?id=#{perfil.id_imagen}") 
          if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |imag|
              imagen = Imagene.new(imag['id'].to_i, imag['nombre'], imag['data'], imag['filename'], imag['tipo'])
            end
          end
              
          postcompleto = Postcompleto.new
          postcompleto.perfil = perfil
          postcompleto.post = posts
          postcompleto.fecha = posts.fecha
          postcompleto.imagen = imagen
          postcompleto.comentario = buscar_comentarios(posts.id)
          @postes << postcompleto
            
        end  
      end
    end
    
    def buscar_comentarios(id_post)
      comentarios = []
      response = RestClient.get("#{BASE_URL}/api/comentarios?id_post=#{id_post}") 
      if (response.code == 200) 
        parsed = JSON.parse(response)
        parsed.each do |commen|
          comentario = Comentario.new(commen['id'].to_i, commen['id_post'].to_i, commen['id_usuario'].to_i, commen['contenido'], commen['fecha'])  
                
          perfils = Perfil.new
          response = RestClient.get("#{BASE_URL}/api/perfils?id_usuario=#{commen['id_usuario']}") 
          if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |pars|
              perfils = Perfil.new(pars['id'].to_i, pars['id_usuario'].to_i, pars['username'], pars['fecha_nacimiento'], pars['telefono'], pars['titulo'], pars['ocupacion'], pars['pais'], pars['ciudad'], pars['estado'], pars['sobre_mi'], pars['id_imagen'].to_i)
            end
          end
                  
          comentariocompleto = Comentariocompleto.new
          comentariocompleto.comentario = comentario
          comentariocompleto.perfil = perfils
          comentarios << comentariocompleto
        end
      end
      return comentarios
    end

end