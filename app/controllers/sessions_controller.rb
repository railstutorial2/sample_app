class SessionsController < ApplicationController
  def new
  	@title = "Sign in"
  end

  def create
  	@title = "Sign in"
  	user = User.authenticate(params[:session][:email],params[:session][:password])
  	if user.nil?
  		flash.now[:error] = "Invalid email/password combination"  		
  		render 'new'

  	#	flash[:notice] = "Wrong login"
  	#	redirect_to signin_path     // ovie dve linii se isto kako prvite dve linii gore
  	else
  	 sign_in user
     redirect_back_or(user) # ili user samo
  	end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  def redirect_back_or(default) 
  #  clear_return_to
    redirect_to(session[:return_to] || default)    
    clear_return_to
  end

  def clear_return_to
    session[:return_to] = nil
  end
end
