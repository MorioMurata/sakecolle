class Public::FavoritesController < ApplicationController

  def create
    favorite = current_user.favorites.new(collection_id: params[:collection_id])
    favorite.save
    @collection = Collection.find(params[:collection_id])
  end

  def destroy
    favorite = Favorite.find_by(collection_id: params[:collection_id], user_id: current_user.id)
    favorite.destroy
    @collection = Collection.find(params[:collection_id])
  end
end
