    class AddSomeIndices < ActiveRecord::Migration
      def change
        add_index :purchase_orders, :owner_id
        add_index :posts, :post_category_id
        add_index :images, [:imagey_id, :imagey_type]
        add_index :contributions, :author_id
        add_index :contributions, :title_id
        add_index :contributions, [:author_id, :title_id]
        add_index :invoices, :owner_id
        add_index :copies, :invoice_line_item_id
      end
    end

