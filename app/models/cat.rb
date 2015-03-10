class Cat < ActiveRecord::Base
  validates :birth_date, :color, :name, :sex, :description, presence: true
  validates :color, inclusion: { in: %w(calico grey white black grumpy) }
  validates :sex, inclusion: { in: %w(M F) }

  def age
    (((Date.today - Cat.first.birth_date).to_i) / 365).to_s + " years"
  end
end
