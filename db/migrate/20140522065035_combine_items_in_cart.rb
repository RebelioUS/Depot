class CombineItemsInCart < ActiveRecord::Migration
  def change
  end

  def up
    Cart.all.each do |cart|
      # подсчёт количества каждого товара в корзине
      sums = cart.line_items.group(:product_id).sum(:quantity)

      sums.each do |product_id, quantity|
        if quantity > 1
          # удаление отдельных записей
          cart.line_items.where(product_id: product_id).delete_all

          # замена одной записью с количеством товарных позиций
          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end
#TODO rollback не работает как надо. Не разделяет элементы на отдельно. Ошибок не даёт
  def down
    # разбиение записей с quantity>1 на несколько записей
    LineItem.where("quantity > 1").each do |line_item|
      # добавляем отдельные записи товарных позиций
      line_item.quantity.times do
        LineItem.create cart_id: line_item.cart_id,
                        product_id: line_item.product_id,
                        quantity: 1
      end

      # удаление исходной записи
      line_item.destroy
    end
  end
end
