#encoding = utf-8
class AdminController < ApplicationController
  def index
    @total_orders = Order.count
  end
end
