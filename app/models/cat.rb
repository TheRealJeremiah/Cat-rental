class Cat < ActiveRecord::Base
  validates :birth_date, :color, :name, :sex, :description, presence: true
  validates :color, inclusion: { in: %w(calico grey white black grumpy) }
  validates :sex, inclusion: { in: %w(M F) }

  belongs_to :owner,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: 'User'

  has_many :cat_rental_requests,
    foreign_key: :cat_id,
    primary_key: :id,
    class_name: 'CatRentalRequest',
    dependent: :destroy

  def age
    (((Date.today - self.birth_date).to_i) / 365).to_s + " years"
  end
end
