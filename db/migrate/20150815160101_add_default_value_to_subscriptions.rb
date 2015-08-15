class AddDefaultValueToSubscriptions < ActiveRecord::Migration
  def change
    change_column :subscriptions, :email, :boolean, default: false
    change_column :subscriptions, :sms, :boolean, default: false
    change_column :subscriptions, :mobile, :boolean, default: false
  end
end
