class UsersController < ApplicationController
    
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy] # so before filter se pravi  povik na metod
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy



  def index
    @users = User.paginate(:page => params[:page])
    @title = "All users"
  end
  def new
  	@title = "Sign up"
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])    
    @microposts = @user.microposts.paginate(:page => params[:page]) # :per_page => 10 za po strana
  	@title = @user.name 
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App"
  		redirect_to @user
  	else
  	@title = "Sign up"
  	render 'new'
  	end
  end
 #taj e novio nacin za mesto params[:user] vo rails 4 !!!, i nema attr_accessible u user.rb veke
  def user_params
    User.new( params.require(:user).permit(:name, :email, :password))
  end

  def edit
   # raise request.inspect
    @user = User.find(params[:id])
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "Profile updated." }

    else 
     @title = "Edit user"
     render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, :flash => { :success => "User destroyed."}
  end

  private 

    def authenticate
      session[:return_to] = request.fullpath # od kade sme dojdeni !!
      flash[:notice] = "You need to sign in to see this page" unless signed_in?
      redirect_to signin_path unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless (current_user.admin? && !current_user?(@user))
    end


end
