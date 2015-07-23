class Restaurant < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  belongs_to :user
  validates :name, length: {minimum: 3}, uniqueness: true
  before_destroy :current_user_created_restaurant
  before_update :current_user_created_restaurant

  attr_accessor :current_user

  def build_review current_user, review_params
    review_params[:restaurant] = self
    current_user.reviews.build(review_params)
  end

  private

  def current_user_created_restaurant
    errmsg = 'You cannot modify this restaurant'
    if user_id != current_user.id
      errors[:base] << errmsg
      return false
    end
  end
end
