class AddPriceToLineItems < ActiveRecord::Migration

  def up
    add_column :line_items, :price, :decimal, precision: 5, scale: 2
    LineItem.all.each do |line_item|
      if line_item.price == nil then
        item = Product.find_by(id: line_item.product_id)
        line_item.update(price: item.price)
      end
    end
  end


  def down
    remove_column :line_items, :price, :decimal, precision: 5, scale: 2
  end

end
