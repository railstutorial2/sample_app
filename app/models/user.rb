# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean          default(FALSE)
#

class User < ActiveRecord::Base
	attr_accessor :password  # factorygirl sets this attr_accessor, zatoa e taa linija
	attr_accessible :name, :email, :password, :password_confirmation#, :admin

  has_many :microposts, :dependent => :destroy # toa znaci deka microposts ke zavisat i koga ke s unisti
                                                # user se unistuvaat i soodvetnite microposts !!
  has_many :relationships, :dependent => :destroy, :foreign_key => "follower_id" 
  has_many :reverse_relationships, :dependent => :destroy, :foreign_key => "followed_id",
                                                 :class_name => "Relationship"
                                                 # se fakuva  deka ima reverse
  has_many :following, :through => :relationships, :source => :followed       
  has_many :followers, :through => :reverse_relationships, :source => :follower                                      

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

   def feed
     Micropost.where("user_id = ?", id)     
   end

   def following?(followed)
     self.relationships.find_by_followed_id(followed)
   end

   def follow!(followed)
     self.relationships.create!(:followed_id => followed.id)
   end

   def unfollow!(followed)
     self.relationships.find_by_followed_id(followed).destroy
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
