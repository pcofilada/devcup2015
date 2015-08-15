class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.attachment :logo
      t.string :title
      t.string :status
      t.string :category
      t.references :owner, polymorphic: true, index: true
      t.string :description

      t.timestamps null: false
    end
  end
end
