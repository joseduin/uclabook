Usuario 
    estatus 0 -> Pendiente por completar perfil
            1 -> Normal
            2 -> Cuenta bloqueada
            
Interes
    estatus 1 -> Activo 
            2 -> Suspendido
            
            
Posts
    tipo    1 -> usuario
            2 -> canal
            
Mensajes
    estatus 1 -> no leido
            2 -> leido
            3 -> eliminado
            
Canal
    estatus 1 -> creado
            2 -> disuelto
            
TEMPLATE: Inspina -> http://webapplayers.com/inspinia_admin-v2.7/mail_detail.html
            
<% # @imagen.each do |parse| %>
                     
    <%= #('<img id="%s" alt="%s" src="data:%s;base64,%s">' 
    % [parse['id'], parse['filename'], parse['tipo'], parse['data']]).html_safe %>

<% # end %>
