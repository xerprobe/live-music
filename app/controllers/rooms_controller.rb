class RoomsController < ApplicationController
  def index; end

  def show; end

  def new
    @room = Room.new
  end

  def create
    @room = current_user.rooms.build(room_params)

    if @room.save
      flash[:notice] = '房间已创建！'
      redirect_to join_rooms_path(token: @room.token)
    else
      render 'new'
    end
  end

  def join
    token = params[:token]
    @room = Room.find_by_token(token)

    if @room
      flash[:notice] = '已加入房间！'
      render 'show'
    else
      flash[:error] = '错误令牌'
      render 'rooms/index'
    end
  end

  def refresh
    id = params[:id]
    room = Room.find_by_id(id)
    room.refresh
    redirect_back(fallback_location: join_rooms_path)
  end

  private

  def room_params
    params.require(:room).permit(:url)
  end
end
