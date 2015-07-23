class Restaurant < ActiveRecord::Base
  has_many :reviews,
      -> { extending WithUserAssociationExtension },
      dependent: :destroy
  belongs_to :user
  validates :name, length: {minimum: 3}, uniqueness: true
  before_destroy :current_user_created_restaurant
  before_update :current_user_created_restaurant

  attr_accessor :current_user

  private

  def current_user_created_restaurant
    errmsg = 'You cannot modify this restaurant'
    if user_id != current_user.id
      errors[:base] << errmsg
      return false
    end
  end
end
