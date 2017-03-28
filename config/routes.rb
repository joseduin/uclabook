Rails.application.routes.draw do
  
  root 'wellcomes#index'

  resources :wellcomes, only: [:error404, :error500, :registrarse, :egresado, :un_paso_mas]
  resources :perfiles, only: [:index, :aliniciar, :show, :editar]
  resources :canales, only: [:index, :show, :canalinformatica, :canalmedicina, :crear_canal]
  resources :mensajes, only: [:show, :chat, :buzon, :redactar_mensaje]
  resources :timelines, only: [:index, :calendario, :contactos, :galeria, :notifications, :poste]
  resources :posts, only: [:show, :postear, :eliminar_post]
  resources :seguids, only: [:seguidores, :seguidos]
  resources :busquedas, only: [:contactos, :canales]
  
  get '/egresado', to: 'wellcomes#egresado'
  get '/registrarse', to: 'wellcomes#registrarse'
  get '/un_paso_mas', to: 'wellcomes#un_paso_mas'
  get '/error404', to: 'wellcomes#error404'
  get '/error500', to: 'wellcomes#error500'
  get '/log_out', to: 'wellcomes#log_out'
  
  get '/perfiles/aliniciar', to: 'perfiles#aliniciar'
  get '/perfiles/mi_perfil/editar', to: 'perfiles#editar'

  get '/canale/informatica', to: 'canales#informatica'
  get '/canale/medicina', to: 'canales#medicina'
  get '/canale/crear_canal', to: 'canales#crear_canal'
  get '/canal/discusion/:id', to: 'canales#discusion'
  post '/canal/unirse_canal/:id', to: 'canales#unirse_canal'
  post '/canal/dejar_canal/:id', to: 'canales#dejar_canal'
  
  get '/mensaje/chat', to: 'mensajes#chat'
  get '/mensaje/buzon', to: 'mensajes#buzon'
  get '/mensaje/enviados', to: 'mensajes#enviados'
  get '/mensaje/eliminados', to: 'mensajes#eliminados'
  get '/mensaje/categoria/:id', to: 'mensajes#categoria'
  get '/mensaje/redactar_mensaje', to: 'mensajes#redactar_mensaje'
  post '/mensaje/eliminar_mensaje/:id', to: 'mensajes#eliminar_mensaje'
  
  get '/timeline/calendario', to: 'timelines#calendario'
  get '/timeline/contactos', to: 'timelines#contactos'
  get '/timeline/galeria/:id', to: 'timelines#galeria'
  get '/timeline/notifications', to: 'timelines#notifications'
  get '/timeline/poste', to: 'timelines#poste'
  get '/timeline/publico', to: 'timelines#publico'
  
  post '/posts/postear', to: 'posts#postear'
  post '/posts/postear_canal', to: 'posts#postear_canal'
  post '/posts/eliminar_post/:id', to: 'posts#eliminar_post'
  post '/posts/comentar', to: 'posts#comentar'
  post '/posts/comentar_canal', to: 'posts#comentar_canal'
  
  get '/seguids/seguidores/:id', to: 'seguids#seguidores'
  get '/seguids/seguidos/:id', to: 'seguids#seguidos'
  post '/seguids/seguir/:id', to: 'seguids#seguir'
  post '/seguids/dejar_de_seguir/:id', to: 'seguids#dejar_de_seguir'

  get '/busquedas/contactos', to: 'busquedas#contactos'
  get '/busquedas/canales', to: 'busquedas#canales'
  get '/busquedas/search', to: 'busquedas#search'

  # Formularios
  post '/wellcome/validar_login', to: 'wellcomes#validar_login'
  post '/wellcome/validar_egresado', to: 'wellcomes#validar_egresado'
  post '/wellcome/validar_registrarse', to: 'wellcomes#validar_registrarse'
  post '/wellcome/validar_un_paso_mas', to: 'wellcomes#validar_un_paso_mas'
  post '/perfiles/validar_editar', to: 'perfiles#validar_editar'
  post '/subir_imagen', to: 'perfiles#subir_imagen'
  post '/canales/subir_imagen', to: 'canales#subir_imagen'
  post '/mensaje/enviar_mensaje', to: 'mensajes#enviar_mensaje'
  post '/canales/validar_crear_canal', to: 'canales#validar_crear_canal'
  
end
