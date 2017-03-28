class BusquedasController < ApplicationController
    before_action :autentificar_usuario?, only: [:search, :contactos, :canales]
    before_action :get_perfil_propio, only: [:search, :contactos, :canales]
    
    def search
        if (params.has_key?(:q))
            redirect_to :controller => 'busquedas', :action => 'contactos', :q => params[:q]
        else
            redirect_to :controller => 'canales', :action => 'index', :cha => params[:cha]
        end
    end
    
    def contactos()
        buscar_seguidos(session[:id])
        @perfiles = []
        response = RestClient.get("#{BASE_URL}/api/usuarios#{ "?username=#{params[:q]}" if params[:q]}") 
        if (response.code == 200) 
            parsed = JSON.parse(response)
            parsed.each do |pars|
                
                perfil = Perfil.new
                response = RestClient.get("#{BASE_URL}/api/perfils?id_usuario=#{pars['id']}") 
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
    
    def canales
        
    end
    
end