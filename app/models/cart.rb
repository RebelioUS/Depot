class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy

  def add_product(product_id, price)
    current_item = line_items.find_by(product_id: product_id)
    #конвертирован в тернарный оператор. Круто
    if current_item then
      current_item.quantity +=1
    else
      current_item = line_items.build(product_id: product_id, price: price)
    end
    current_item
  end

  def total_price
    line_items.to_a.sum {|item| item.total_price}
  end
end
