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
      #Google Vision AI APIによる画像識別機能↓
      if @collection.sake_image.save
        tags = Vision.get_image_data(@collection.sake_image)
        tags.each do |tag|
          @collection.tags.create(name: tag)
        end
      end
      #Google Vision AI APIによる画像識別機能↑
      redirect_to user_path(@collection.user_id)
    else
      #投稿に失敗したら新規投稿画面へ
      @new_collection = Collection.new
      @user = current_user
      @collections = @user.collections
      render :new
    end
  end

  def index
    #collectionのindexは存在しないため、indexへの遷移を回避
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
      #open_date（開栓日時）カラムの日時情報をリセット（消去）
      collection.open_date = nil
    end
    #ストロングパラメータ下update_collection_paramsメソッドの呼び出し
    post_params = update_collection_params
    #1,2の文字列を整数に変換し、enumに格納
    post_params[:tastes_rich] = post_params[:tastes_rich]&.to_i
    post_params[:tastes_sweet] = post_params[:tastes_sweet]&.to_i
    post_params[:is_aromatic] = post_params[:is_aromatic]&.to_i
    if collection.update(post_params)
      redirect_to user_path(collection.user_id)
    else
      @user = current_user
      @collection = @user.collections
      @edit_collection = collection
      render :edit
    end
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
