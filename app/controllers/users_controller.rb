class UsersController < ApplicationController
    
  before_filter :authenticate, :only => [:edit, :update] # so before filter se pravi  povik na metod

  def new
  	@title = "Sign up"
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
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

  private 

    def authenticate
      flash[:notice] = "You need to sign in to see this page"
      redirect_to signin_path unless signed_in?
    end


end
