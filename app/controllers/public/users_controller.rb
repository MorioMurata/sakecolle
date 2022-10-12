class Public::UsersController < ApplicationController
  def edit
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
end
