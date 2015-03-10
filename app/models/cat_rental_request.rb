class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: %w(PENDING APPROVED DENIED) }
  validate :overlapping_approved_requests

  after_initialize do
    self.status ||= "PENDING"
  end

  belongs_to :cat,
    foreign_key: :cat_id,
    primary_key: :id,
    class_name: 'Cat'

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
    CatRentalRequest.where("((start_date >= ? AND start_date <= ?) OR (end_date >= ? AND end_date <= ?) OR
                            (start_date <= ? AND end_date >= ?)) AND id != ?",
                             self.start_date, self.end_date, self.start_date, self.end_date,
                             self.start_date, self.end_date, self.id)
  end

  def overlapping_approved_requests
    unless overlapping_requests.where(status: "APPROVED").empty?
      errors[:base] << "There were overlapping requests"
    end
  end
end
