class MensajesController < ApplicationController
    before_action :autentificar_usuario?, only: [:show, :buzon, :redactar_mensaje, :enviados, :eliminados, :categoria]
    before_action :get_perfil_propio, only: [:show, :buzon, :redactar_mensaje, :enviados, :eliminados, :categoria]
    
    def show
        response = RestClient.get("#{BASE_URL}/api/chats?id=#{params[:id]}") 
        if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |parse|
                mensaje = Chat.new(parse['id'].to_i, parse['id_usuario'].to_i, parse['id_usuario2'].to_i, parse['categoria'].to_i, parse['asunto'], parse['contenido'], parse['estatus'].to_i, parse['fecha'])
            
                perfil = Perfil.new
                response = RestClient.get("#{BASE_URL}/api/perfils?id_usuario=#{parse['id_usuario']}") 
                if (response.code == 200) 
                    parsed = JSON.parse(response)
                    parsed.each do |user|
                        perfil = Perfil.new(user['id'].to_i, user['id_usuario'].to_i, user['username'], user['fecha_nacimiento'], user['telefono'], user['titulo'], user['ocupacion'], user['pais'], user['ciudad'], user['estado'], user['sobre_mi'], user['id_imagen'].to_i)
                    end
                end
                
                @mensaje = Mensajecompleto.new(mensaje, perfil)
            end
        end
        
        if @mensaje.chat.id_usuario2.to_i == session[:id]
            if @mensaje.chat.estatus.to_i == 1
                RestClient.put("#{BASE_URL}/api/chats/#{@mensaje.chat.id}", 
                    { chat: { 
                      estatus: 2
                    }}) 
            end
        end
    end
    
    def eliminados
        @mensajes = []
        response = RestClient.get("#{BASE_URL}/api/chats?estatus=3&id_usuario=#{session[:id]}&?order=updated_at:desc") 
        if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |parse|
                mensaje = Chat.new(parse['id'].to_i, parse['id_usuario'].to_i, parse['id_usuario2'].to_i, parse['categoria'].to_i, parse['asunto'], parse['contenido'], parse['estatus'].to_i, parse['fecha'])
            
                perfil = Perfil.new
                response = RestClient.get("#{BASE_URL}/api/perfils?id_usuario=#{parse['id_usuario']}") 
                if (response.code == 200) 
                    parsed = JSON.parse(response)
                    parsed.each do |user|
                        perfil = Perfil.new(user['id'].to_i, user['id_usuario'].to_i, user['username'], user['fecha_nacimiento'], user['telefono'], user['titulo'], user['ocupacion'], user['pais'], user['ciudad'], user['estado'], user['sobre_mi'], user['id_imagen'].to_i)
                    end
                end
                
                @mensajes << Mensajecompleto.new(mensaje, perfil)
            end
        end 
    end
    
    def categoria
        @mensajes = []
        response = RestClient.get("#{BASE_URL}/api/chats?categoria=#{params[:id]}&id_usuario=#{session[:id]}&?order=created_at:desc") 
        if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |parse|
                mensaje = Chat.new(parse['id'].to_i, parse['id_usuario'].to_i, parse['id_usuario2'].to_i, parse['categoria'].to_i, parse['asunto'], parse['contenido'], parse['estatus'].to_i, parse['fecha'])
            
                perfil = Perfil.new
                response = RestClient.get("#{BASE_URL}/api/perfils?id_usuario=#{parse['id_usuario']}") 
                if (response.code == 200) 
                    parsed = JSON.parse(response)
                    parsed.each do |user|
                        perfil = Perfil.new(user['id'].to_i, user['id_usuario'].to_i, user['username'], user['fecha_nacimiento'], user['telefono'], user['titulo'], user['ocupacion'], user['pais'], user['ciudad'], user['estado'], user['sobre_mi'], user['id_imagen'].to_i)
                    end
                end
                
                # Bandeja entrada y salida no muestra los eliminados
                unless mensaje.estatus.to_i == 3
                    @mensajes << Mensajecompleto.new(mensaje, perfil)
                end
            end
        end  
        
        response = RestClient.get("#{BASE_URL}/api/chats?categoria=#{params[:id]}&id_usuario2=#{session[:id]}&?order=created_at:desc") 
        if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |parse|
                mensaje = Chat.new(parse['id'].to_i, parse['id_usuario'].to_i, parse['id_usuario2'].to_i, parse['categoria'].to_i, parse['asunto'], parse['contenido'], parse['estatus'].to_i, parse['fecha'])
            
                perfil = Perfil.new
                response = RestClient.get("#{BASE_URL}/api/perfils?id_usuario=#{parse["#{tipo}"]}") 
                if (response.code == 200) 
                    parsed = JSON.parse(response)
                    parsed.each do |user|
                        perfil = Perfil.new(user['id'].to_i, user['id_usuario'].to_i, user['username'], user['fecha_nacimiento'], user['telefono'], user['titulo'], user['ocupacion'], user['pais'], user['ciudad'], user['estado'], user['sobre_mi'], user['id_imagen'].to_i)
                    end
                end
                
                # Bandeja entrada y salida no muestra los eliminados
                unless mensaje.estatus.to_i == 3
                    @mensajes << Mensajecompleto.new(mensaje, perfil)
                end
            end
        end
        @mensajes.sort! { |a,b| Time.parse(b.chat.fecha) <=> Time.parse(a.chat.fecha) }
    end
    
    def eliminar_mensaje
        RestClient.put("#{BASE_URL}/api/chats/#{params[:id]}", 
            { chat: { 
                estatus: 3
            }})
    
        if (response.code == 200) 
            redirect_to :controller => 'mensajes', :action => 'buzon'
        else
            redirect_to :controller => 'mensajes', :action => 'buzon'
        end
    end
    
    def chat
        
    end
    
    def buzon
        buscar_mensajes(true)
    end
    
    def enviados
        buscar_mensajes(false)
    end
    
    def redactar_mensaje
        @usuarios = []
        response = RestClient.get("#{BASE_URL}/api/usuarios") 
        if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |parse|
                unless parse['id'].to_i == session[:id]
                    @usuarios << Usuario.new(parse['id'].to_i, parse['role_id'], parse['username'], parse['pass'], parse['email'], parse['estatus'], parse['cedula'], parse['nacionalidad'])
                end
            end
        end
    end
    
    def enviar_mensaje
        response = RestClient.post("#{BASE_URL}/api/chats", 
            {chat: { 
                id_usuario: session[:id],
                id_usuario2: params[:id_usuario2],
                categoria: params[:categoria],
                asunto: params[:asunto],
                contenido: params[:contenido], 
                fecha: "#{Time.now}",
                estatus: 1
            }})
    
        if (response.code == 201) 
            redirect_to :controller => 'mensajes', :action => 'enviados'
        else
            redirect_to :controller => 'mensajes', :action => 'enviados'
        end
    end
    
    private
    
    def buscar_mensajes(bool)
        if bool == true
            usuario = "id_usuario2=#{session[:id]}"  
            tipo = "id_usuario"
        else
            usuario = "id_usuario=#{session[:id]}"
            tipo = "id_usuario2"   
        end
        @bool = bool
        @mensajes = []
        response = RestClient.get("#{BASE_URL}/api/chats?#{usuario}&?order=created_at:desc") 
        if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |parse|
                mensaje = Chat.new(parse['id'].to_i, parse['id_usuario'].to_i, parse['id_usuario2'].to_i, parse['categoria'].to_i, parse['asunto'], parse['contenido'], parse['estatus'].to_i, parse['fecha'])
            
                perfil = Perfil.new
                response = RestClient.get("#{BASE_URL}/api/perfils?id_usuario=#{parse["#{tipo}"]}") 
                if (response.code == 200) 
                    parsed = JSON.parse(response)
                    parsed.each do |user|
                        perfil = Perfil.new(user['id'].to_i, user['id_usuario'].to_i, user['username'], user['fecha_nacimiento'], user['telefono'], user['titulo'], user['ocupacion'], user['pais'], user['ciudad'], user['estado'], user['sobre_mi'], user['id_imagen'].to_i)
                    end
                end
                
                # Bandeja entrada y salida no muestra los eliminados
                unless mensaje.estatus.to_i == 3
                    @mensajes << Mensajecompleto.new(mensaje, perfil)
                end
            end
        end 
    end
    
end