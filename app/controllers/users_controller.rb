class UsersController < ApplicationController

    before_action:authenticate_user,{only:[:index, :show, :edit, :update]}
    before_action:forbid_login_user,{only:[:new, :create, :login_form, :login]}
    before_action:ensure_correct_user, {only:[:edit, :update]}

    def index
        @users = User.all
    end

    def show
        @user = User.find_by(id: params[:id]) 
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(name: params[:name], email: params[:email], gender: params[:gender], age: params[:age], password: params[:password])
        if @user.save
            session[:user_id] = @user.id
            redirect_to("/users/#{@user.id}")
        else 
            render "users/new", status: :unprocessable_entity
        end    
    end

    def edit
        @user = User.find_by(id: params[:id])
    end

    def update
        @user = User.find_by(id: params[:id])            
        @user.name = params[:name]            
        @user.email = params[:email]            
        @user.gender = params[:gender]            
        @user.age = params[:age]            
        if @user.save            
            flash[:notice] = "ユーザー情報を編集しました"            
            redirect_to("/users/#{@user.id}")            
        else            
            render"users/edit", status: :unprocessable_entity            
        end
    end

    def login_form

    end
    def login
        @user = User.find_by(email: params[:email], password: params[:password])
        if @user
            session[:user_id] = @user.id
            redirect_to("/post/index")
        else    
            @error_message="メールアドレスまたはパスワードが間違っています"
            @email = params[:email]
            @password = params[:password]
            render"users/login_form", status: :unprocessable_entity 
        end
    end

    def logout
        session[:user_id] = nil
        redirect_to("/login")

    end

    def ensure_correct_user
        if @current_user.id != params[:id].to_i
            redirect_to("/posts/index")
        end
    end
end
