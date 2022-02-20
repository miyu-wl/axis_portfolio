class UsersController < ApplicationController
  before_action :non_login_user, only: [:logout, :show, :index, :setting, :setting_update]
  before_action :login_user, only: [:new, :create, :login_form, :login]
  def new
    @user = User.new
  end

  def create
    @user = User.new(
      name: params[:name],
      real_name: params[:real_name],
      email: params[:email],
      grade: params[:grade],
      password: params[:password]
    )

    if @user.save
      session[:id] = @user.id
      flash[:notice] = '新規登録に成功しました'
      redirect_to('/users/index')
    else
      render('users/new')
    end
  end

  def login_form
  end

  def login
    @user = User.find_by(
      email: params[:email],
    )

    if @user && @user.authenticate(params[:password])
      session[:id] = @user.id
      flash[:notice] = 'ログインに成功しました'
      redirect_to('/users/index')
    else
      flash[:notice] = 'emailまたはpasswordが違います'
      render('users/login_form')
    end
  end

  def logout
    session[:id] = nil
    flash[:notice] = 'ログアウトしました'
    redirect_to('/')
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def index
    @users = User.all
  end

  def setting
    @user = User.find_by(id: session[:id])
  end

  def setting_update
    @user = User.find_by(id: session[:id])
    @user.name = params[:name]
    @user.real_name = params[:real_name]
    @user.grade = params[:grade]
    @user.email = params[:email]

    if @user.authenticate(params[:password])
      if @user.save
        flash[:notice] = '設定を更新しました'
        redirect_to('/users/setting')
      else
        render('users/setting')
      end
    else
      flash[:notice] = "正しいパスワードを入力してください"
      render('users/setting')
    end
  end
end

def login_user
  if @current_user
    redirect_to('/users/index')
  end
end

def non_login_user
  if @current_user == nil
    flash[:notice] = 'ログインしてください'
    redirect_to('/')
  end
end