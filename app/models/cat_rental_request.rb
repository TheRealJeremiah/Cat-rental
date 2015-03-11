class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, :user_id, presence: true
  validates :status, inclusion: { in: %w(PENDING APPROVED DENIED) }
  validate :overlapping_approved_requests

  after_initialize do
    self.status ||= "PENDING"
  end

  belongs_to :cat,
    foreign_key: :cat_id,
    primary_key: :id,
    class_name: 'Cat'

  belongs_to :user,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: 'User'

  def approve!
    self.status = "APPROVED"
    self.save

    overlapping_requests.update_all(status: "DENIED")
  end

  def deny!
    self.status = "DENIED"
    self.save
  end

  private

  def overlapping_requests
    CatRentalRequest
      .where("(:id IS NULL) OR (id != :id)", id: self.id)
      .where(cat_id: cat_id)
      .where(<<-SQL, start_date: start_date, end_date: end_date)
       NOT( (start_date > :end_date) OR (end_date < :start_date) )
SQL
  end

  def overlapping_approved_requests
    unless overlapping_requests.where(status: "APPROVED").empty?
      errors[:base] << "There were overlapping requests"
    end
  end
end
