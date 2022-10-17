class Public::FavoritesController < ApplicationController

  def create
    favorite = current_user.favorites.new(collection_id: params[:collection_id])
    favorite.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    favorite = Favorite.find_by(collection_id: params[:collection_id], user_id: current_user.id)
    favorite.destroy
    redirect_back(fallback_location: root_path)
  end
end
