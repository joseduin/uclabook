class CanalesController < ApplicationController
    before_action :autentificar_usuario?, only: [:index, :crear_canal, :show, :discusion]
    before_action :get_perfil_propio, only: [:index, :crear_canal, :show, :discusion]

    def index
      @canales = []
      response = RestClient.get("#{BASE_URL}/api/canals#{ "?nombre=#{params[:cha]}" if params[:cha]}")
      if (response.code == 200) 
        parsed = JSON.parse(response)
        parsed.each do |canal|
          buscar_integrantes_canal(canal['id'])
          # por falta de tiempo no uso el estatus :( asi que le dare otro uso -> total de integrantes por grupo
          
          canale = Canal.new(canal['id'].to_i, canal['id_creador'].to_i, canal['id_interes'].to_i, canal['id_imagen'].to_i, canal['nombre'], canal['descripcion'], canal['estatus'].to_i)
          
          image = Imagene.new
          response = RestClient.get("#{BASE_URL}/api/imagenes?id=#{canal['id_imagen']}") 
          if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |imagen|
              image = Imagene.new(imagen['id'].to_i, imagen['nombre'], imagen['data'], imagen['filename'], imagen['tipo'])
            end
          end
          
          @canales << Canalcompleto.new(canale, image, @integrantes_canal)
        end
      end
    end
    
    def show
      buscar_integrantes_canal(params[:id])
      
        @canal = Canal.new
        @imagen_canal = Imagene.new
        @interes = Intere.new
        response = RestClient.get("#{BASE_URL}/api/canals?id=#{params[:id]}")
        if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |canal|
                @canal = Canal.new(canal['id'].to_i, canal['id_creador'].to_i, canal['id_interes'].to_i, canal['id_imagen'].to_i, canal['nombre'], canal['descripcion'], canal['estatus'].to_i)
            
                response = RestClient.get("#{BASE_URL}/api/imagenes?id=#{canal['id_imagen']}") 
                if (response.code == 200) 
                  parsed = JSON.parse(response)
                  parsed.each do |imagen|
                    @imagen_canal = Imagene.new(imagen['id'].to_i, imagen['nombre'], imagen['data'], imagen['filename'], imagen['tipo'])
                  end
                end
                
                response = RestClient.get("#{BASE_URL}/api/interes?id=#{canal['id_interes']}") 
                if (response.code == 200) 
                   parsed = JSON.parse(response)
                   parsed.each do |parse|
                      @interes = Intere.new(parse['id'].to_i, parse['nombre'], parse['descripcion'], parse['estatus'].to_i)          
                   end
                end
            
            end
        end
        
        #Buscar integrantes, contando con el creador
        @integrantes = []
        perfil = Perfil.new
        image = Imagene.new
        response = RestClient.get("#{BASE_URL}/api/perfils?id_usuario=#{@canal.id_creador}") 
        if (response.code == 200)
          parsed = JSON.parse(response)
          parsed.each do |parse|
            perfil = Perfil.new(parse['id'].to_i, parse['id_usuario'].to_i, parse['username'], parse['fecha_nacimiento'], parse['telefono'], parse['titulo'], parse['ocupacion'], parse['pais'], parse['ciudad'], parse['estado'], parse['sobre_mi'], parse['id_imagen'].to_i)
           
            # Buscamos el perfil del usuario
            
            response = RestClient.get("#{BASE_URL}/api/imagenes?id=#{perfil.id_imagen}") 
            if (response.code == 200) 
              parsed = JSON.parse(response)
              parsed.each do |imagen|
                image = Imagene.new(imagen['id'].to_i, imagen['nombre'], imagen['data'], imagen['filename'], imagen['tipo'])
              end
            end
          end
          @integrantes << Canalintegrante.new(perfil, image)
        end
        
        response = RestClient.get("#{BASE_URL}/api/usuariocanals?id_canal=#{@canal.id}") 
        if (response.code == 200)
          parsed = JSON.parse(response)
          parsed.each do |canls|
          
            perfil = Perfil.new
            image = Imagene.new
            response = RestClient.get("#{BASE_URL}/api/perfils?id_usuario=#{canls['id_usuario']}") 
            if (response.code == 200)
              parsed = JSON.parse(response)
              parsed.each do |parse|
                perfil = Perfil.new(parse['id'].to_i, parse['id_usuario'].to_i, parse['username'], parse['fecha_nacimiento'], parse['telefono'], parse['titulo'], parse['ocupacion'], parse['pais'], parse['ciudad'], parse['estado'], parse['sobre_mi'], parse['id_imagen'].to_i)
               
                # Buscamos el perfil del usuario
                response = RestClient.get("#{BASE_URL}/api/imagenes?id=#{@perfil.id_imagen}") 
                if (response.code == 200) 
                  parsed = JSON.parse(response)
                  parsed.each do |imagen|
                    image = Imagene.new(imagen['id'].to_i, imagen['nombre'], imagen['data'], imagen['filename'], imagen['tipo'])
                  end
                end
              end
              @integrantes << Canalintegrante.new(perfil, image)
            end          
              
          end
        end
        
        @discuiones = []
        response = RestClient.get("#{BASE_URL}/api/discusiones?id_canal=#{params[:id]}") 
          if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |parse|
                posts = Post.new(parse['id'].to_i, '', parse['id_usuario'].to_i, parse['id_canal'].to_i, parse['titulo'], parse['contenido'], parse['fecha'], parse['estatus'])          
            
                comentarios = []
                  response = RestClient.get("#{BASE_URL}/api/comentariodiscucions?id_post=#{parse['id']}") 
                  if (response.code == 200) 
                    parsed = JSON.parse(response)
                    parsed.each do |commen|
                      comentario = Comentario.new(commen['id'].to_i, commen['id_post'].to_i, commen['id_usuario'].to_i, commen['contenido'], commen['fecha'])  
                    
                      perfil = Perfil.new
                      response = RestClient.get("#{BASE_URL}/api/perfils?id_usuario=#{commen['id_usuario']}") 
                      if (response.code == 200) 
                        parsed = JSON.parse(response)
                        parsed.each do |pars|
                          perfil = Perfil.new(pars['id'].to_i, pars['id_usuario'].to_i, pars['username'], pars['fecha_nacimiento'], pars['telefono'], pars['titulo'], pars['ocupacion'], pars['pais'], pars['ciudad'], pars['estado'], pars['sobre_mi'], pars['id_imagen'].to_i)
                        end
                      end
                      
                      comentariocompleto = Comentariocompleto.new
                      comentariocompleto.comentario = comentario
                      comentariocompleto.perfil = perfil
                      comentarios << comentariocompleto
                    end
                  end
                  
                  postcompleto = Postcompleto.new
                  postcompleto.post = posts
                  postcompleto.comentario = comentarios
                  @discuiones << postcompleto
            end
        end
        
    end
    
    def discusion
        @discusion = Postcompleto.new
        response = RestClient.get("#{BASE_URL}/api/discusiones?id=#{params[:id]}") 
          if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |parse|
                posts = Post.new(parse['id'].to_i, '', parse['id_usuario'].to_i, parse['id_canal'].to_i, parse['titulo'], parse['contenido'], parse['fecha'], parse['estatus'])          
            
                comentarios = []
                  response = RestClient.get("#{BASE_URL}/api/comentariodiscucions?id_post=#{parse['id']}") 
                  if (response.code == 200) 
                    parsed = JSON.parse(response)
                    parsed.each do |commen|
                      comentario = Comentario.new(commen['id'].to_i, commen['id_post'].to_i, commen['id_usuario'].to_i, commen['contenido'], commen['fecha'])  
                    
                      perfil = Perfil.new
                      response = RestClient.get("#{BASE_URL}/api/perfils?id_usuario=#{commen['id_usuario']}") 
                      if (response.code == 200) 
                        parsed = JSON.parse(response)
                        parsed.each do |pars|
                          perfil = Perfil.new(pars['id'].to_i, pars['id_usuario'].to_i, pars['username'], pars['fecha_nacimiento'], pars['telefono'], pars['titulo'], pars['ocupacion'], pars['pais'], pars['ciudad'], pars['estado'], pars['sobre_mi'], pars['id_imagen'].to_i)
                        end
                      end
                      
                      comentariocompleto = Comentariocompleto.new
                      comentariocompleto.comentario = comentario
                      comentariocompleto.perfil = perfil
                      comentarios << comentariocompleto
                    end
                  end
                  
                  postcompleto = Postcompleto.new
                  postcompleto.post = posts
                  postcompleto.comentario = comentarios
                  @discusion = postcompleto
            end
        end
    end
    
    def subir_imagen
        # Guardamos la Imagen
      response = RestClient.post("#{BASE_URL}/api/imagenes", 
              { imagene: { 
                  nombre: params[:foto].original_filename,
                  filename: params[:foto].original_filename,
                  tipo: params[:foto].content_type.chomp,
                  data: Base64.encode64( params[:foto].read )
              }})
              
      if (response.code == 201)
        # Buscamos la imagen acorde
        response = RestClient.get("#{BASE_URL}/api/imagenes?order=created_at:desc") 
        if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |parse|
             
              
                  # Guardamos los datos de canal
                  response = RestClient.put("#{BASE_URL}/api/canals/#{params[:id_canal]}", 
                     { canal: { 
                        id_imagen: parse['id'].to_i
                     }})
                  if (response.code == 201)
            
                  end
        
              
              # romper el ciclo de las imagenes
              break
            end
        end
      end
      redirect_to(:back)
    end
    
    def informatica
        
    end
    
    def medicina
        
    end
    
    def crear_canal
        @intereses = []
        interes = Intere.new
        response = RestClient.get("#{BASE_URL}/api/interes") 
        if (response.code == 200) 
           parsed = JSON.parse(response)
           parsed.each do |parse|
              interes = Intere.new(parse['id'].to_i, parse['nombre'], parse['descripcion'], parse['estatus'].to_i)          
              @intereses << interes
           end
        end
    end
    
    def validar_crear_canal
        response = RestClient.post("#{BASE_URL}/api/imagenes", 
            { imagene: { 
                nombre: params[:foto].original_filename,
                filename: params[:foto].original_filename,
                tipo: params[:foto].content_type.chomp,
                data: Base64.encode64( params[:foto].read )
            }})
              
        if (response.code == 201)
            # Buscamos la imagen acorde
            response = RestClient.get("#{BASE_URL}/api/imagenes?order=created_at:desc")
            #?nombre=#{nombre_imagen}") 
            if (response.code == 200) 
                parsed = JSON.parse(response)
                parsed.each do |parse|
                
                    # Guardamos los datos del canal
                    RestClient.post("#{BASE_URL}/api/canals", 
                     { canal: { 
                        id_creador: session[:id].to_i,
                        id_interes: params[:interes].to_i,
                        nombre: params[:nombre],
                        descripcion: params[:descripcion],
                        estatus: 1,
                        id_imagen: parse['id'].to_i
                     }})
                
                # Rompemos el ciclo de las imagenes
                break
                end
                
                # Buscamos el ultimo canal que con el id del creador(el que acaba de crear)
                response = RestClient.get("#{BASE_URL}/api/canals?id_creador=#{session[:id]}&order=created_at:desc")
                if (response.code == 200) 
                    parsed = JSON.parse(response)
                    parsed.each do |parse|
                       redirect_to canale_path(parse['id'].to_i)
                    break 
                    end
                end
            end
        end
    end
    
    def unirse_canal
      RestClient.post("#{BASE_URL}/api/usuariocanals", 
        { usuariocanal: { 
            id_usuario: session[:id].to_i,
            id_canal: params[:id].to_i
        }})
      redirect_to(:back)
    end
    
    def dejar_canal
      response = RestClient.get("#{BASE_URL}/api/usuariocanals?id_usuario=#{session[:id]}&id_canal=#{params[:id]}")
      if (response.code == 200) 
        parsed = JSON.parse(response)
        parsed.each do |parse|
          
          response = RestClient.delete("#{BASE_URL}/api/usuariocanals/#{parse['id']}") 
          if response == 204
          else    
          end
        end
      end
      redirect_to(:back)
    end
    
    private
    
end