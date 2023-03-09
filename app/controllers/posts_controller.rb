class PostsController < ApplicationController

  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    @post = Post.find_by(id: params[:id] )
    @user = User.find_by(id: @post.user_id)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(actorname: params[:actorname], 
      title:params[:title],
      evaluation: params[:evaluation],
      score: params[:score],
      impression: params[:impression],

      user_id: @current_user.id )
    
    if @post.save
      redirect_to("/posts/index")
    else 
      render "posts/new", status: :unprocessable_entity
    end 
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])

    @post.actorname = params[:actorname]
    @post.title = params[:title]
    @post.evaluation =params[:evaluation]
    @post.score =params[:score]
    @post.impression =params[:impression]

    if @post.save
      redirect_to("/posts/index")
    else 
      render "posts/edit", status: :unprocessable_entity
    end  

  end

  def destroy
    @post = Post.find_by(id: params[:id])
    if @post.destroy 
      redirect_to("/posts/index")
    end
  end



  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
  flash[:notice] = "権限がありません"
  redirect_to("/posts/index")
    end
  end  

  def search
    if params[:actorname].present?
      @posts = Post.where('actorname LIKE ?', "%#{params[:actorname]}%")
    elsif params[:title].present?
      @posts = Post.where('title LIKE ?', "%#{params[:title]}%")
    elsif params[:evaluation].present?
      @posts = Post.where(' evaluation LIKE ?', "%#{params[:evaluation]}%")
    elsif params[:score].present?
      @posts = Post.where(' score LIKE ?', "%#{params[:score]}%")
    elsif params[:impression].present?
      @posts = Post.where('impression LIKE ?', "%#{params[:impression]}%")

    else
      @posts = Post.none
    end
  end





end
