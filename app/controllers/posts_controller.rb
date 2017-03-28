class PostsController < ApplicationController
    layout "guest"
    
    def show
      @web_url = WEB_URL
      @web_uft8 = WEB_UFT8
      
      posts = Post.new
      @postcompleto = Postcompleto.new
      response = RestClient.get("#{BASE_URL}/api/posts?id=#{params[:id]}") 
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
          
          @postcompleto.perfil = perfil
          @postcompleto.post = posts
          @postcompleto.imagen = imagen
        end
      else
         redirect_to error404_path
      end
    end
    
    def postear
        response = RestClient.post("#{BASE_URL}/api/posts", 
            {post: { 
                tipo: 1,
                id_usuario: session[:id],
                id_canal: 0,
                titulo: params[:titulo],
                contenido: params[:contenido], 
                fecha: "#{Time.now}",
                estatus: 1
            }})
    
        if (response.code == 201) 
            redirect_to(:back)
        else
            redirect_to(:back)
        end
    end
    
    def postear_canal
        response = RestClient.post("#{BASE_URL}/api/discusiones", 
            {discusione: { 
                id_usuario: session[:id],
                id_canal: params[:id_canal],
                titulo: params[:titulo],
                contenido: params[:contenido], 
                fecha: "#{Time.now}",
                estatus: 1
            }})
    
        if (response.code == 201) 
            redirect_to(:back)
        else
            redirect_to(:back)
        end
    end
    
    def comentar_canal
      response = RestClient.post("#{BASE_URL}/api/comentariodiscucions", 
            {comentariodiscucion: { 
                id_post: params[:id_post],
                id_usuario: session[:id],
                contenido: params[:contenido], 
                fecha: "#{Time.now}",
            }})
    
      if (response.code == 201) 
          redirect_to(:back)
      else
          redirect_to(:back)
      end
    end
    
    def comentar
      response = RestClient.post("#{BASE_URL}/api/comentarios", 
            {comentario: { 
                id_post: params[:id_post],
                id_usuario: session[:id],
                contenido: params[:contenido], 
                fecha: "#{Time.now}",
            }})
    
      if (response.code == 201) 
          redirect_to(:back)
      else
          redirect_to(:back)
      end
    end
    
    def eliminar_post
      response = RestClient.delete("#{BASE_URL}/api/posts/#{params[:id]}") 
    
        if (response.code == 200) 
            redirect_to(:back)
        else
            redirect_to(:back)
        end
    end
    
    private
    
end