class Member < ActiveRecord::Base
    
    has_many :pages
    has_many :documents
    has_many :posts
end
