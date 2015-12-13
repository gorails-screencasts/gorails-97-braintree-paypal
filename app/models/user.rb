class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  def subscribed?
    braintree_id? && braintree_subscription_id?
  end
end
