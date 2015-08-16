class Api::V1::AnnouncementsController < ApplicationController
  before_action :authenticate_with_token
  before_action :set_channel, only: [:create]

  def create
    announcement = @channel.announcements.new(announcement_params)

    if announcement.save
      render json: announcement, status: 201
      notify(announcement)
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

  def notify(announcement)
    client = Chikka::Client.new(client_id: "#{Rails.application.secrets.client_id}",
                                secret_key: "#{Rails.application.secrets.secret_key}",
                                shortcode: "#{Rails.application.secrets.shortcode}")
    @channel.subscriptions.sms_enabled.each do |sms|
      client.send_message(message: announcement.message, mobile_number: "#{sms.user.mobile_number}")
    end

    @channel.subscriptions.email_enabled.each do |email|
      UserMailer.send_notification(email.user, announcement).deliver
    end
  end

end
