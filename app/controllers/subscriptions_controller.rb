class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    if current_user.braintree_id?
      customer = Braintree::Customer.find(current_user.braintree_id)
    else
      result = Braintree::Customer.create(
        email: current_user.email,
        payment_method_nonce: params[:payment_method_nonce]
      )
      customer = result.customer
      current_user.update(braintree_id: customer.id)
    end

    result = Braintree::Subscription.create(
      payment_method_token: customer.payment_methods.find{ |pm| pm.default? }.token,
      plan_id: params[:plan_id]
    )
    current_user.update(braintree_subscription_id: result.subscription.id)

    redirect_to root_path, notice: "You have been subscribed"
  end
end
