class Review < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :user
  validates :rating, inclusion: (1..5)
  validates :user, uniqueness: { scope: :restaurant, message: "has reviewed this restaurant already" }

  def destroy_as(user)
    return false unless self.user == user
    destroy
    true
  end
end
