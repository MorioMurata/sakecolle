class Public::CollectionCommentsController < ApplicationController
before_action :authenticate_user!

  def create
    @collection = Collection.find(params[:collection_id])
    @comment = current_user.collection_comments.new(collection_comment_params)
    @comment.collection_id = @collection.id
    if @comment.save
      redirect_to collection_path(@collection)
    else
      @user = @collection.user
      @user_collection = @collection.user.collections
      @collection_comment = CollectionComment.new
      render '/public/collections/show'
    end
  end

  def index
    redirect_to collection_path(params[:collection_id])
  end

  def destroy
    CollectionComment.find(params[:id]).destroy
    redirect_to collection_path(params[:collection_id])
  end

  private

  def collection_comment_params
    params.require(:collection_comment).permit(:comment)
  end
end
