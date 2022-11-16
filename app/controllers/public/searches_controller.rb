class Public::SearchesController < ApplicationController
  before_action :authenticate_user!
  
  def search
    @users = User.looks(params[:word])
    @word = params[:word]
  end 
    
end
