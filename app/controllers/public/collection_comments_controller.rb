class Public::CollectionCommentsController < ApplicationController

  def create
    collection = Collection.find(params[:collection_id])
    comment = current_user.collection_comments.new(collection_comment_params)
    comment.collection_id = collection.id
    comment.save
    redirect_to collection_path(collection)
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
