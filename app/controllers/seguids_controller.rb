class SeguidsController < ApplicationController
    before_action :autentificar_usuario?, only: [:seguidores, :seguidos]
    before_action :get_perfil_propio, only: [:seguidores, :seguidos]
    
    def seguidores
        seguids(false, "id_seguidor", params[:id])
    end
    
    def seguidos
        seguids(true, "id_seguido", params[:id])
    end
    
    def seguir
        RestClient.post("#{BASE_URL}/api/seguidores", 
        { seguidore: { 
            id_usuario: params[:id].to_i,
            id_seguidor: session[:id].to_i
        }})
      
        RestClient.post("#{BASE_URL}/api/seguidos", 
            { seguido: { 
                id_usuario: session[:id].to_i,
                id_seguido: params[:id].to_i
            }})
        redirect_to(:back)
    end
    
    def dejar_de_seguir
        # Buscamos el id de la relacion seguidor
        response = RestClient.get("#{BASE_URL}/api/seguidores?id_usuario=#{params[:id]}&id_seguidor=#{session[:id]}") 
        if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |parse|
                
                # Eliminarmos el registro de seguidor
                response = RestClient.delete("#{BASE_URL}/api/seguidores/#{parse['id']}") 
                if response == 204
                else    
                end
            end
        end
        
        # Buscamos el id de la relacion seguido
        response = RestClient.get("#{BASE_URL}/api/seguidos?id_usuario=#{session[:id]}&id_seguido=#{params[:id]}") 
        if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |pars|
                            
                # Borramos el registro de seguido
                response = RestClient.delete("#{BASE_URL}/api/seguidos/#{pars['id']}") 
                if response == 204
                else
                end
            end
        end
        redirect_to(:back) 
    end
    
    private 
    
    def seguids(bool, seguid, id)
        query = ""
        if bool
            query = "seguidos"
        else
            query = "seguidores"
        end
        
        buscar_seguidos(session[:id])
        @perfiles = []
        response = RestClient.get("#{BASE_URL}/api/#{query}?id_usuario=#{id}") 
        if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |pars|
                
                perfil = Perfil.new
                response = RestClient.get("#{BASE_URL}/api/perfils?id_usuario=#{pars["#{seguid}"]}") 
                if (response.code == 200)
                    parsed = JSON.parse(response)
                    parsed.each do |parse|
                        perfil = Perfil.new(parse['id'].to_i, parse['id_usuario'].to_i, parse['username'], parse['fecha_nacimiento'], parse['telefono'], parse['titulo'], parse['ocupacion'], parse['pais'], parse['ciudad'], parse['estado'], parse['sobre_mi'], parse['id_imagen'].to_i)
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
                
                completo = Postcompleto.new
                completo.perfil = perfil
                completo.imagen = imagen
                @perfiles << completo
            end
        end
    end
    
end