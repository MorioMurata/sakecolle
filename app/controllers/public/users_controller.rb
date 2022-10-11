class Public::UsersController < ApplicationController
  def edit
  end

  def index
    @users = User.all
  end

  def show
    if params[:past].present?
    else
    end 
    @collections = Collection.all
  end
end
