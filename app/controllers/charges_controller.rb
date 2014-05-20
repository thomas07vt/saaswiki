class ChargesController < ApplicationController
  
  def new

    # # Because large hashes in haml are no fun
    # @stripe_btn_hash = {
    #   src: "https://checkout.stripe.com/checkout.js", 
    #   class: 'stripe-button',
    #   data: {
    #     key: "#{ Rails.configuration.stripe[:publishable_key] }",
    #     description: "WikiWrite Premium Membership - #{current_user.username}",
    #     amount: 10
    #     # We're like the Snapchat for Wikipedia. But really, 
    #     # change this amount. Stripe won't charge $9 billion.
    #   }
    # }
  end



  def create
    @user = User.find(current_user.id)

    #The Amount is in cents.
    @amount = 1000 #I need base this off of a plan rather than it just being hardcoded. I Don't want to add ":amount" to the form b/c that is editable by the client.

    # Creates a Stripe Customer object, for associating
    # with the charge
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken],
      :plan => "premium"
    )

    @user.update_attributes(stripe_id: customer.id)

    # # Where the real magic happens
    # charge = Stripe::Charge.create(
    #   customer: customer.id, # Note -- this is NOT the user_id in your app
    #   amount: @amount,
    #   description: "WikiWrite Premium Membership - #{current_user.email}",
    #   currency: 'usd'
    # )

    flash[:success] = "Thank you for your payment, #{current_user.username}!"
    redirect_to dashboard_path # or wherever

  # Stripe will send back CardErrors, with friendly messages
  # when something goes wrong.
  # This `rescue block` catches and displays those errors.
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end
