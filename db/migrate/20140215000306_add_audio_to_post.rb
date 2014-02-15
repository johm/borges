class AddAudioToPost < ActiveRecord::Migration
  def change
    add_column :posts,:audio,:string
  end
end
