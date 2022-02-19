class PostsController < ApplicationController
  before_action :non_login_user
  before_action :correct_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(
      year: params[:year],
      month: params[:month],
      tytle: params[:tytle],
      background: params[:background],
      aim: params[:aim],
      do: params[:do],
      notice: params[:notice],
      user_id: session[:id]
    )

    if @post.save
      flash[:notice] = '投稿が保存されました'
      redirect_to("/users/#{session[:id]}")
    else
      render('posts/new')
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    post = Post.find_by(id: params[:id])
    post.year = params[:year]
    post.month = params[:month]
    post.tytle = params[:tytle]
    post.background = params[:background]
    post.aim = params[:aim]
    post.do = params[:do]
    post.notice = params[:notice]

    if post.save
      flash[:notice] = '編集が保存されました'
      redirect_to("/posts/#{post.id}/edit")
    else
      render("posts/#{post.id}/edit")
    end
  end

  def destroy
    post = Post.find_by(id: params[:id])
    post.destroy
    flash[:notice] = '投稿が削除されました'
    render('home/top')
  end

  # before_actions

  def non_login_user
    if @current_user == nil
      flash[:notice] = 'ログインしてください'
      redirect_to('/')
    end
  end

  def correct_user
    unless session[:id] == params[:id]
      flash[:notice] = '権限がありません'
      redirect_to('/users/index')
    end
  end
end
