class Admin::CollectionCommentsController < ApplicationController
  def index
    redirect_to admin_collection_path(params[:collection_id])
  end

  def destroy
    CollectionComment.find(params[:id]).destroy
    redirect_to admin_collection_path(params[:collection_id])
  end
end
