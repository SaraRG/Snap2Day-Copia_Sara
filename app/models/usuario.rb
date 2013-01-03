class Usuario < ActiveRecord::Base
	attr_accessible :admin, :username
	
	authenticates_with_sorcery!
	
	has_many :posts

	validates_confirmation_of :password, message: "Ambos campos deben coincidir", if: :password
	validates_length_of :password, :minimum => 5, :too_short => "El password debe tener al menos 5 caracteres"
	validates_uniqueness_of :username, message: "El nombre de usuario ya existe."
	validates_presence_of :username, message: "Debe introducir un nombre de usuario."
	validates_presence_of :email, message: "Debe introducir un email"
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create, message: "Introduzca un email con el formato correcto"
	validates_presence_of :password, message: "Debe introducir un password"
end