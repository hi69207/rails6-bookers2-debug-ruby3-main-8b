class UsersController < ApplicationController
  before_action :ensure_currect_user, only: [:edit, :update]
  before_action :authenticate_user!, only: [:show]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    #@books = @user.books.page(params[:page]).reverse_order
    #@today_book =  @books.created_today
    #@yesterday_book = @books.created_yesterday
    #@this_week_book = @books.created_this_week
    #@last_week_book = @books.created_last_week
    @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: @user.id)
    if @user.id == current_user.id
    else
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  def following
    @title = "Follow Users"
    @user  = User.find(params[:id])
    @users = @user.following
    render 'show_follow'
  end

  def followers
    @title = "Follower Users"
    @user  = User.find(params[:id])
    @users = @user.followers
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_currect_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
