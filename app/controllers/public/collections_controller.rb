class Public::CollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:update, :edit, :destroy]

  def new
    @new_collection = Collection.new
    @user = current_user
    @collections = @user.collections
  end

  def create
    @collection = Collection.new(collection_params)
    @collection.user_id = current_user.id
    if @collection.save
      redirect_to user_path(@collection.user_id)
    else
      @new_collection = Collection.new
      @user = current_user
      @collections = @user.collections
      render :new
    end
  end

  def index
    redirect_to new_collection_path
  end

  def show
    @collection = Collection.find(params[:id])
    @user = @collection.user
    @user_collection = @collection.user.collections
    @collection_comment = CollectionComment.new
  end

  def destroy
    @collection = Collection.find(params[:id])
    @collection.destroy
    redirect_to user_path(@collection.user_id)
  end

  def edit
    @edit_collection = Collection.find(params[:id])
    @user = current_user
    @collection = @user.collections
    # redirect_to root_path, notice: 'Error' if current_user.id != @collection.user_id
  end

  def update
    collection = Collection.find(params[:id])
    #現在のremain_amountカラムが未開栓、かつURLに送られてきたremain_amountが未開栓でない（未開栓以外のステータスに変更されている）場合
    if collection.remain_amount == "unopened" && params[:collection][:remain_amount] != "unopened"
      #open_date（開栓日時）カラムに日時情報を格納
      collection.open_date = Time.current
    #現在のremain_amountカラムが未開栓でなく、かつURLに送られてきたremain_amountが未開栓の（未開栓以外のステータスから未開栓に変更されている）場合
    #=誤操作により、開栓済みにしてしまった投稿を未開栓の状態に修正するための分岐
    elsif collection.remain_amount != "unopened" &&  params[:collection][:remain_amount] == "unopened"
      #open_date（開栓日時）カラムの日時情報をリセット（消去
      collection.open_date = nil
    end
    post_params = update_collection_params
    post_params[:tastes_rich] = Integer(post_params[:tastes_rich])
    post_params[:tastes_sweet] = Integer(post_params[:tastes_sweet])
    post_params[:is_aromatic] = Integer(post_params[:is_aromatic])
    collection.update(post_params)
    redirect_to user_path(collection.user_id)
  end

  private

  def collection_params
    params.require(:collection).permit(:sake_name, :sake_image)
  end

  def update_collection_params
    params.require(:collection).permit(:sake_name, :sake_image, :remain_amount, :tastes_rich, :tastes_sweet, :is_aromatic)
  end

  def ensure_correct_user
    @collection = Collection.find(params[:id])
    @user = @collection.user
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
