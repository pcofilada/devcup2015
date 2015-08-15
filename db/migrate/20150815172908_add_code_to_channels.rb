class AddCodeToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :code, :string
  end
end
