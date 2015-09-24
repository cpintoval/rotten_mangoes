class Movie < ActiveRecord::Base

  has_many :reviews

  validates :title, presence: true
  validates :director, presence: true
  validates :runtime_in_minutes, numericality: { only_integer: true }
  validates :description, presence: true
  validates :poster_image_url, presence: true
  validates :release_date, presence: true
  validate :release_date_is_in_the_future

  scope :title_match, -> (term) { where("title LIKE ?", "%#{term}%") }
  scope :director_match, -> (term) { where("director LIKE ?", "%#{term}%") }
  scope :runtime_under_90_minutes, -> { where("runtime_in_minutes < 90") }
  scope :runtime_between_90_and_120_minutes, -> { where(runtime_in_minutes: 90..120) }
  scope :runtime_above_120_minutes, -> { where("runtime_in_minutes > 120") }

  def review_average
    reviews.size > 0 ? reviews.sum(:rating_out_of_ten)/reviews.size : 0
  end

  protected

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should probably be in the future") if release_date < Date.today
    end
  end

end
