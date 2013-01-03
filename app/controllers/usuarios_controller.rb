class UsuariosController < ApplicationController
  # before_filter :authenticate, :except => [:show, :new, :create]
#  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  # before_filter :correct_user, :only => [:edit, :update]
  # before_filter :admin_user,   :only => :destroy
  # before_filter :admin_user,   :only => :index
    # skip_before_filter :require_login, :only => [:index, :new, :create, :activate, :login_from_http_basic]
    before_filter :require_login, :only => [:index, :activate]
    before_filter :require_admin, :only => :index 
  
  # GET /usuarios
  # GET /usuarios.json
  def index
    @usuarios = Usuario.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @usuarios }
    end
  end

  # GET /usuarios/1
  # GET /usuarios/1.json
  def show
    @usuario = Usuario.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @usuario }
    end
  end

  # GET /usuarios/new
  # GET /usuarios/new.json
  def new
    @usuario = Usuario.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @usuario }
    end
  end

  # POST /usuarios
  # POST /usuarios.json
  def create
    @usuario = Usuario.new(params[:usuario])
    datos = params[:usuario].to_hash

    if @usuario.save
      if @usu = login(datos["username"],datos["password"])
        redirect_to @usu, notice: 'Usuario creado y logueado correctamente.'
        # redirect_to(@usuario, notice: "Usuario creado y logueado correctamente.")
      else
        flash.now[:alert] = "Algo salio mal con el login."
        render action: :new
      end
    else
      flash.now[:alert] = "Ha habido un problema al crear el usuario."
      render action: "new"
    end

    # Lo que estaba antes.
    # respond_to do |format|
    #   if @usuario.save
    #     format.html { redirect_to @usuario, notice: 'Usuario creado correctamente.' }
    #     format.json { render json: @usuario, status: :created, location: @usuario }
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: @usuario.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # GET /usuarios/1/edit
  def edit
    @usuario = Usuario.find(params[:id])
  end

  # PUT /usuarios/1
  # PUT /usuarios/1.json
  def update
    @usuario = Usuario.find(params[:id])

    respond_to do |format|
      if @usuario.update_attributes(params[:usuario])
        format.html { redirect_to @usuario, notice: 'Usuario actualizado correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usuarios/1
  # DELETE /usuarios/1.json
  def destroy
    @usuario = Usuario.find(params[:id])
    @usuario.destroy

    respond_to do |format|
      format.html { redirect_to usuarios_url }
      format.json { head :no_content }
    end
  end

  # private
  #   def signed_in?
  #     !current_user.nil?
  #   end
  #   def authenticate
  #     deny_access unless signed_in?
  #   end

  #   def correct_user
  #     @user = User.find(params[:id])
  #     redirect_to(root_path) unless current_user?(@user)
  #   end
  #   def admin_user
  #     redirect_to(root_path) unless current_user.admin?
  #   end

  # The before filter requires authentication using HTTP Basic,
  # And this action redirects and sets a success notice.
  def require_admin
        redirect_to(root_path) unless current_user.admin?
  end
end
