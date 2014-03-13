class SessionsController < ApplicationController
  def new
  	@title = "Sign in"
  end

  def create
  	user = User.authenticate(params[:session][:email],params[:session][:password])
  	if user.nil?
  		flash.now[:error] = "Invalid email/password combination"  		
  		render 'new'
  		@title = "Sign in"
  	#	flash[:notice] = "Wrong login"
  	#	redirect_to signin_path     // ovie dve linii se isto kako prvite dve linii gore
  	else
  	
  	end
  end

  def destroy

  end
end
