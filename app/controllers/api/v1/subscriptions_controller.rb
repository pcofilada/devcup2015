class Api::V1::SubscriptionsController < ApplicationController
  before_action :authenticate_with_token
  before_action :set_channel, only: [:create, :update]

  def create
    subscription = Subscription.new(subscription_params)
    subscription.user = current_user
    subscription.channel = @channel

    if subscription.save
      render json: subscription, status: 201
    else
      render json: { errors: subscription.errors.full_messages }, status: 422
    end
  end

  def update
    subscription = Subscription.where(channel: @channel, user: current_user).find(params[:id])
    subscription.status = 'inactive'

    if subscription.save
      render json: subscription, status: 201
    else
      render json: { errors: subscription.errors.full_messages }, status: 422
    end
  end

private

  def set_channel
    @channel = Channel.find(params[:channel_id])
  end

  def subscription_params
    params.require(:subscription).permit(:email, :sms, :mobile)
  end
end
