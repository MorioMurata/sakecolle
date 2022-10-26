class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.all
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

  def destroy
    User.find(params[:id]).destroy
    redirect_to admin_users_path
  end

  private

  def admin_user

  end

end
