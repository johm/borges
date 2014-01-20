class AddEvenMoreStuffToEvents < ActiveRecord::Migration
  def change
    add_column :events,:rental_payment_info,:text
    add_column :events,:facebook_url,:text
  end
end
