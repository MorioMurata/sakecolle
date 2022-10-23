class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:edit]

  def edit
    @user = User.find(params[:id])
    @collection = @user.collections
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  def index
    @user = current_user
    @users = User.all
    #ユーザーの一覧に自分を除く全ユーザーを表示させる
    @user_index = @users.where.not(id: current_user.id)
    @collection = @user.collections
  end

  def show
    @user = User.find(params[:id])
    @collection = @user.collections
    #past collectionが選択された(=URLに:pastがある)時
    if params[:past].present?
    #残量ステータスが"完飲"の投稿を呼び出し(.finishはenumのカラム名)
      @collections = @collection.finish
    #collectionが選択された(=URLに:pastがない)時
    else
    #残量ステータスが"完飲"ではない投稿を呼び出し
      @collections = @collection.where.not(remain_amount: 'finish')
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
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end

  def favorites
    @user = User.find(params[:id])
    @collection = @user.collections
    favorites = Favorite.where(user_id: @user.id).pluck(:collection_id)
    @favorite_collections = Collection.find(favorites)
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :profile_image, :introduction, :stocking_capacity)
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.email == "guest@example.com"
      flash[:notice] = 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
      redirect_to user_path(current_user)
    end
  end
end
