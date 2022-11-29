class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  #退会済みユーザーを表示させない、操作させないための記述
  before_action :ensure_active_user, except: [:edit, :update, :index, :unsubscribe]

  before_action :ensure_correct_user, only: [:update, :edit, :withdrawal, :unsubscribe]
  #ゲストユーザーにユーザー編集をさせないための記述
  before_action :ensure_guest_user, only: [:edit]

  def edit
    @user = current_user
    @collections = @user.collections
  end

  def update
    user = current_user
    if user.update(user_params)
      redirect_to user_path(user.id)
    else
      @user = user
      @collections = user.collections
      render :edit
    end
  end

  def index
    @user = current_user
    @users = User.all
    #ユーザーの一覧に自分を除く全ユーザーを表示させる
    @user_index = User.where.not(id: current_user.id).where(is_deleted: false).page(params[:page]).per(4)
    #ページ内検索の部分一致が成立した投稿、かつ自分を除くユーザーを表示。
    if params[:word].present?
      #looksメソッドはuser.rbモデルに記載。
      @user_index = User.looks(params[:word]).where.not(id: current_user.id).where(is_deleted: false).page(params[:page]).per(4)
    end
    @collections = @user.collections
  end

  def show
    @user_collections = @collections.where.not(remain_amount: 'finish')
    #非同期通信のタブ機能により完飲前/完飲後の投稿を分けて表示。それぞれのインスタンス変数を定義。
    @current_collections = @user_collections.page(params[:page]).per(5)
    #非同期のタブ切り替えに伴い、ページネーションも非同期でリンクさせるためparamsに渡す値を分けている。
    @past_collections = @collections.finish.page(params[:post_page]).per(5)
      #ページネーション非同期化ための記述
      respond_to do |format|
        format.html
        format.js
      end
  end

  def follows
    @users = @user.followings.where(is_deleted: false)
  end

  def followers
    @users = @user.followers.where(is_deleted: false)
  end

  def unsubscribe
  end

  def withdrawal
    @user.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end

  def favorites
    #いいね（cheers）した投稿一覧の表示
    favorites = Favorite.where(user_id: @user.id).pluck(:collection_id)
    @favorite_collections = Collection.where(id: favorites).page(params[:page]).per(5)
    #いいね（cheers）した投稿一覧のページ内検索で部分一致した投稿を表示
    if params[:word].present?
      @favorite_collections = Collection.looks(params[:word]).where(id: favorites).page(params[:page]).per(5)
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :profile_image, :introduction, :stocking_capacity)
  end

  def ensure_active_user
    @user = get_user()
    @collections = @user.collections
  end

  def ensure_correct_user
    @user = get_user()
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def ensure_guest_user
    @user = get_user()
    if @user.is_guest?
      flash[:notice] = 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
      redirect_to user_path(current_user)
    end
  end
  
  def get_user
    user = User.find_by(id: params[:id])
    if user.nil?
      redirect_to users_path()
    end
    if user.active_for_authentication? == false
      flash[:notice] = '退会済みユーザーは表示できません。'
      redirect_to user_path(current_user)
    end
    return user
  end
  
    
end
