module SessionsHelper
	
	def sign_in(user)
		cookies.permanent.signed[:remember_token] = [user.id, user.salt]  
	# id se encryptira so salt !
	# da se zapomni sign in status na logiranje // secure way // slednoto e isto so prethodnoto
	# cookies[:remember_token] =  { :value => user.id, :expires => 20.years.from.utc }
	  current_user = user	
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user?(user)
		user == current_user
	end

	 def authenticate
      session[:return_to] = request.fullpath # od kade sme dojdeni !!
      flash[:notice] = "You need to sign in to see this page" unless signed_in?
      redirect_to signin_path unless signed_in?
    end

	def deny_access
		store_location
		redirect_to signin_path, :notice => "Please sign in to access this page."
	end

	def store_location
		session[:return_to] = request.fullpath
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		clear_return_to
	end

	def clear_return_to
		session[:return_to] = nil
	end

	def current_user 
		@current_user ||= user_from_remember_token
		# isto so @current_user = @current_user || user_from_rememeber_token
		# da ne odi do bazata ako go ima veke userot
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		cookies.delete(:remember_token)
		#self.current_user = nil
	 	current_user = nil # // ova ne raboti !!
	 	session[:return_to] = nil
	end

	private

	def user_from_remember_token
		User.authenticate_with_salt(*remember_token) # flatten mu pravi na poleto
	end

	def remember_token
		cookies.signed[:remember_token] || [nil, nil]
	end

end
