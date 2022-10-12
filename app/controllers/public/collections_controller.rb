class Public::CollectionsController < ApplicationController
  def new
    @collection = Collection.new
  end

  def create
    @collection = Collection.new(collection_params)
    @collection.user_id = current_user.id
   
    @collection.save
    redirect_to my_page_path(@collection.user_id)
  end

  def show
    @collection = Collection.find(params[:id])
    @collection_comment = CollectionComment.new
  end

  def destroy
    @collection = Collection.find(params[:id])
    @collection.destroy
    redirect_to my_page_path(@collection.user_id)
  end

  def edit
    @collection = Collection.find(params[:id])
  end

  def update
    collection = Collection.find(params[:id])
 
    if collection.remain_amount == "unopened" && params[:collection][:remain_amount] != "unopened"
      collection.open_date = Time.current
    elsif collection.remain_amount != "unopened" &&  params[:collection][:remain_amount] == "unopened"
      collection.open_date = nil
    end
    collection.update(update_collection_params)
    redirect_to my_page_path(collection.user_id)
  end

  private

  def collection_params
    params.require(:collection).permit(:sake_name, :sake_image)
  end

  def update_collection_params
    params.require(:collection).permit(:sake_name, :sake_image, :remain_amount, :tastes_rich, :tastes_sweet, :is_aromatic)
  end
end
