ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_many :contributions
    has_secure_password
    # validates :mail,
    #     presence: true,
    #     format: {with:/\A.+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+\z/}
    # validates :password,
    #     format: {with:/(?=.*?[a-z])(?=.*?[0-9])/},
    #     length: {in: 5..10}
end

class Contribution < ActiveRecord::Base
    belongs_to :user
    belongs_to :category
end    
class Category < ActiveRecord::Base
    has_many :contributions, dependent: :destroy
end