class AddVerifiedToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :verified, :boolean, default: false
  end
end
