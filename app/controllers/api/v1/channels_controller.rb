class Api::V1::ChannelsController < ApplicationController
  before_action :authenticate_with_token, only: [:index]

  def index
    channels = current_user.channels

    render json: channels, status: 200
  end

end
