class Public::UsersController < ApplicationController
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    #past collectionが選択された(=URLに:pastがある)時
    if params[:past].present?
    #残量ステータスが"完飲"の投稿を呼び出し(.finishはenumのカラム名)
      @collections = Collection.finish
    #collectionが選択された(=URLに:pastがない)時
    else
    #残量ステータスが"完飲"ではない投稿を呼び出し
      @collections = Collection.where.not(remain_amount: 'finish')
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :profile_image, :introduction, :stocking_capacity)
  end

end
