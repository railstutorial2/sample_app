class UsersController < ApplicationController
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
end
