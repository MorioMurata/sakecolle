class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:update, :edit, :withdrawal, :unsubscribe]
  #ゲストユーザーにユーザー編集をさせないための記述
  before_action :ensure_guest_user, only: [:edit]

  def edit
    @user = current_user
    @collection = @user.collections
  end

  def update
    user = current_user
    if user.update(user_params)
      redirect_to user_path(user.id)
    else
      @user = user
      @collection = user.collections
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
    @collection = @user.collections
  end

  def show
    @user = User.find(params[:id])
    @collection = @user.collections
    #非同期通信のタブ機能により完飲前/完飲後の投稿を分けて表示。それぞれのインスタンス変数を定義。
    @collections = @collection.where.not(remain_amount: 'finish').page(params[:page]).per(5)
    #非同期のタブ切り替えに伴い、ページネーションも非同期でリンクさせるためparamsに渡す値を分けている。
    @past_collections = @collection.finish.page(params[:post_page]).per(5)
      #ページネーション非同期化ための記述
      respond_to do |format|
        format.html
        format.js
      end
  end

  def follows
    @user = User.find(params[:id])
    @collection = @user.collections
    @users = @user.followings
  end

  def followers
    @user = User.find(params[:id])
    @collection = @user.collections
    @users = @user.followers
  end

  def unsubscribe
  end

  def withdrawal
    @user = User.find(params[:id])
    @user.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end

  def favorites
    @user = User.find(params[:id])
    @collection = @user.collections
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

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.email == "guest@example.com"
      flash[:notice] = 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
      redirect_to user_path(current_user)
    end
  end
end
