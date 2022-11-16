class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:update, :edit, :withdrawal, :unsubscribe]
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
    if params[:word].present?
      @user_index = User.looks(params[:word]).where.not(id: current_user.id).where(is_deleted: false).page(params[:page]).per(4)
    end
    @collection = @user.collections
  end

  def show
    @user = User.find(params[:id])
    @collection = @user.collections
    @collections = @collection.where.not(remain_amount: 'finish').page(params[:page]).per(5)
    @past_collections = @collection.finish.page(params[:post_page]).per(5)
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
    favorites = Favorite.where(user_id: @user.id).pluck(:collection_id)
    @favorite_collections = Collection.where(id: favorites).page(params[:page]).per(5)
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
