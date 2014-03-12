class User < ActiveRecord::Base
	attr_accessor :password
	#attr_accessible :name, :email, :password, :password_confirmation
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
    
end
