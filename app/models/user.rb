class User < ApplicationRecord
    validates :name, {presence:true}
    validates :email, {presence:true, uniqueness: true}
    validates :gender, {presence:true}
    validates :age, {presence:true}
    validates :password, {presence: true}

    def posts
        return Post.where(user_id: self.id)
    end 

    # 検索方法分岐
    def self.looks(search, word)
        if search == "perfect_match"
            @user = User.where("name LIKE?", "#{word}")
        elsif search == "forward_match"
            @user = User.where("name LIKE?","#{word}%")
        elsif search == "backward_match"
            @user = User.where("name LIKE?","%#{word}")
        elsif search == "partial_match"
            @user = User.where("name LIKE?","%#{word}%")
        else
            @user = User.all
        end
    end
    
    
end
