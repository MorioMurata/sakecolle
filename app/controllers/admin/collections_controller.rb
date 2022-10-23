class Admin::CollectionsController < ApplicationController
  before_action :authenticate_user!

  def show
    @collection = Collection.find(params[:id])
    @user = @collection.user
    @user_collection = @collection.user.collections
    @collection_comment = CollectionComment.new
  end

end
