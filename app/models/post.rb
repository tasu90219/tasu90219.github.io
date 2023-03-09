class Post < ApplicationRecord
    belongs_to :user
    validates :actorname,{presence: true}
    validates :title,{presence: true}
    validates :evaluation,{presence: true}
    validates :score,allow_blank: true, numericality: {only_integer: true}, length: { maximum:1 }
    validates :impression, {presence: true, length: {minimum: 5, maximum: 140} }
    validates :user_id, {presence: true}

    def user
        return User.find_by(id: self.user_id)
    end 


    
end
