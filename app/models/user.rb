class User < ActiveRecord::Base
	attr_accessor :password  # factorygirl sets this attr_accessor, zatoa e taa linija
	attr_accessible :name, :email, :password, :password_confirmation
	#attr_accessible :name, :email  // ova e loso iam problemi nekoi
	validates_presence_of :name, :email
	validates :name, :length => { :maximum => 50}
	validates :email, :format => { with: /\A[\w+.\-]+@[a-z.\-\d]+\.[a-z]+\z/i} 
	validates :email, :uniqueness => { :case_sensitive => false} # true za uniknes e implicitno
    # /i na kraj e za case insensitive, a \A na pocetok e pocetok na string, a \z na kraj
    # e kraj na string
   # validates :name, presence: true
   validates :password, :presence => true, :confirmation => true
   validates :password, :length => { :within => 6..40}

   before_save :encrypt_password 

   def has_password?(submitted_password)
     encrypted_password == encrypt(submitted_password)
   end
        # self. e KLASEN METOD
   def self.authenticate(email, submitted_password)
     user = find_by_email(email)
     (user && user.has_password?(submitted_password)) ? user : nil # isto kako dolnite 2
  #   return nil if user.nil?
  #   return user if user.has_password?(submitted_password)
   end

   def self.authenticate_with_salt(id, cookie_salt)
     user = find_by_id(id)
     (user && user.salt == cookie_salt) ? user : nil  
   end

   private


   def encrypt_password
   	 self.salt = make_salt if new_record?
     self.encrypted_password = encrypt(password)  # moze i self.password
   end



   def encrypt(string)
   	 secure_hash("#{salt}--#{string}")
   end

   def make_salt
     secure_hash("#{Time.now.utc}--#{password}")
   end


   def secure_hash(string)
   	Digest::SHA2.hexdigest(string)
   end
    
end
