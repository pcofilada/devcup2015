class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :title
      t.string :message
      t.belongs_to :channel, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
