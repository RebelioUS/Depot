# coding: utf-8
class Product < ActiveRecord::Base

  has_many :line_items
  has_many :orders, through: :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, :presence => true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
      with: %r{\.(gif|jpg|jpeg|png)\Z}i,
      message: 'URL должен указывать на изображение формата GIF, JPG, PNG.'
  }

  def self.latest
    Product.order(:updated_at).last
  end

  private
  #Убеждаемся в отсутствии покупок ссылающихся на данный товар
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'существует товарная позиция (покупка)')
      return false
    end
  end

end
