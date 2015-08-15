class Api::V1::ChannelsController < ApplicationController
  before_action :authenticate_with_token, only: [:index, :create]

  def index
    channels = current_user.channels

    render json: channels, status: 200
  end

  def create
    channel = current_user.channels.new(channel_params)

    if channel.save
      render json: channel, status: 201
    else
      render json: { errors: channel.errors.full_messages }, status: 422
    end
  end

private

  def channel_params
    params.require(:channel).permit(:logo, :title, :description, :status, :category)
  end

end
