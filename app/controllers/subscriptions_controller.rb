class SubscriptionsController < ApplicationController
  def new
    @user = User.new
    planid = params[:plan].to_i || 0

    if !Plan.where(pid: planid).any?
      @plan = Plan.where(pid: 0).first
    else
      @plan = Plan.where(pid: planid).first
    end
    @price = @plan.cost
    
  end


  def create
    @user = User.find(current_user.id)
    @plan = Plan.where(pid: @user.plan).first

    # Creates a Stripe Customer object, for associating
    # with the charge
    customer = Stripe::Customer.create(
      email: @user.email,
      card: params[:stripeToken],
      :plan => @plan.name
    )

    @user.update_attributes(stripe_id: customer.id, plan: @plan.pid)

    flash[:success] = "You have successfully sign up for for the #{@plan.name.titleize}!"
    redirect_to dashboard_path # or wherever

  # Stripe will send back CardErrors, with friendly messages
  # when something goes wrong.
  # This `rescue block` catches and displays those errors.
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end


  def finalize
    @user = User.find(current_user.id)
    #I only want to be here when this is the user's first time
    if @user.sign_in_count == 1 && @user.plan != 0
      token = @user.stripe_tok
    else
      return redirect_to authenticated_root_path
    end

    # Abort if the token is not set
    if token.nil? || token.length < 2
      flash[:error] = "There was an error processing your credit card information. Please update your credit card information, but in the meantime enjoy our free subscription!"
      @user.update_attributes(plan: 0, stripe_tok:  nil)
      return redirect_to authenticated_root_path
    end

    @plan = Plan.where(pid: @user.plan).first

    # Creates a Stripe Customer object, for associating
    # with the charge
    customer = Stripe::Customer.create(
      email: @user.email,
      card: token,
      plan: @plan.name
    )

    @user.update_attributes(stripe_id: customer.id, plan: @plan.pid, stripe_tok: nil)

    flash[:success] = "You have successfully sign up for for the #{@plan.name.titleize}!"
    redirect_to dashboard_path

  # Stripe will send back CardErrors, with friendly messages
  # when something goes wrong.
  # This `rescue block` catches and displays those errors.
  rescue Stripe::CardError => e
    flash[:error] = "There was an error processing your credit card information. Please update your credit card information, but in the meantime enjoy our free subscription! " + e.message
    @user.update_attributes(plan: 0, stripe_tok: nil)
    redirect_to new_charge_path
  end

  def cancel
  end

  def edit 
    @user = current_user
    @plan = Plan.where(pid: @user.plan).first
    @card = {}
    # Grab customer info from stripe if they 
    if @plan.pid != 0
      cards = Stripe::Customer.retrieve(@user.stripe_id).cards.all(:limit => 1)
      @card[:last4] = cards[:data][0][:last4]
      @card[:type] = cards[:data][0][:type]
    end

  rescue
    @card[:last4] = "****"
    @card[:type] = "credit"
  end

  def update
    @user = current_user
    newplan = Plan.where(pid: params[:plan]).first
    use_old_card = !params[:use_existing_card].nil?
    token = params[:stripeToken]

    # If the customer wants to use the free subscription, then we need to delete the stripe account if it exists
    if newplan.pid == 0
      if @user.stripe_id
        # Delete stripe customer
        customer = Stripe::Customer.retrieve(@user.stripe_id)
        customer.delete
      end
      # Update customer info
      @user.update_attributes(stripe_id: nil, plan: newplan.pid, stripe_tok: nil)

    # Update Customer subscription with the same card (do nothing if they selected the same card and the same plan).
    elsif (use_old_card && !@user.stripe_id.nil? && newplan.pid != @user.plan)
      customer = Stripe::Customer.retrieve(@user.stripe_id)
      subscriptions = Stripe::Customer.retrieve(@user.stripe_id).subscriptions.all(:limit => 1)
      subscription = customer.subscriptions.retrieve(subscriptions[:data][0][:id])
      subscription.plan = newplan.name
      subscription.save

      # Update customer info
      @user.update_attributes(plan: newplan.pid)

    elsif !use_old_card # Update user plan and card info
      # If the customer already exits, We need to update his plan, otherwise we need to create a stripe customer.
      if @user.stripe_id
        # Updated customer card info
        customer = Stripe::Customer.retrieve(@user.stripe_id)
        subscriptions = Stripe::Customer.retrieve(@user.stripe_id).subscriptions.all(:limit => 1)
        subscription = customer.subscriptions.retrieve(subscriptions[:data][0][:id])
        subscription.plan = newplan.name
        subscription.card = token
        subscription.save
      else
        # Creates a Stripe Customer object, for associating
        # with the charge
        customer = Stripe::Customer.create(
          email: @user.email,
          card: token,
          plan: newplan.name
        )
      end
      # Update customer info
      @user.update_attributes(stripe_id: customer.id, plan: newplan.pid)
    else
    end

    flash[:notice] = "Subscription information updated successfully!"
    redirect_to edit_subscription_path(@user)

  # rescue
  #   flash[:error] = "There was an error updating your subscription information. Please try again."
  #   redirect_to edit_subscription_path(@user)
  end

end
