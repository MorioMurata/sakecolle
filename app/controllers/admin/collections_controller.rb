class Admin::CollectionsController < ApplicationController
  
  def show
    @collection = Collection.find(params[:id])
    @collection_comment = CollectionComment.new
  end
  
end
