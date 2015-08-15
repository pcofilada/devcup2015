class Api::V1::AnnouncementsController < ApplicationController
  before_action :authenticate_with_token
  before_action :set_channel, only: [:create]

  def create
    announcement = @channel.announcements.new(announcement_params)

    if announcement.save
      render json: announcement, status: 201
    else
      render json: { errors: announcement.errors.full_messages }
    end
  end
  
private

  def set_channel
    @channel = current_user.channels.find(params[:channel_id]) 
  end

  def announcement_params
    params.require(:announcement).permit(:title, :message)
  end

end
