class StripeService

  attr_accessor :user, :cust_id, :one_time_tok

  # Initialize the stripe service object with a required User ID, and an optional one-time token from stipe.
  def initialize(user_id, tok = nil)
    @user = User.find(user_id)
    @cust_id = @user.stripe_id if @user.stripe_id
    @one_time_tok = tok if tok
  end

  def cancel
    # Right now this never gets called...
    if self.user.stripe_id
      # Delete Stripe customer.
      self.delete_customer
      self.cust_id = nil
    end

  rescue
    # I should log this so I can manually delete the user information... since the user account will get deleted.
  end

  def update(newplan)
    result = {}
    role = :basic
    last4 = nil

    # One Time token should already be set if the customer is using a new card... otherwise use old card....
    # If the user chooses a free plan, then we need to delete their stripe account.
    if newplan.pid == 0
      if self.user.stripe_id
        # Delete Stripe customer.
        self.delete_customer
        self.cust_id = nil
      end
    else
      # If the customer already has a Stripe account, then we simply need to update the subscription plan.
      if self.cust_id
        self.update_subscription(newplan.name)
      # Otherwise, we need to create a new account for the customer.
      else
        customer = self.create_customer(newplan.name)
        self.cust_id = customer.id
      end
        role = :premium
        last4 = self.get_card_last_4
    end

    # Update customer info
    self.user.update_attributes(stripe_id: self.cust_id, plan: newplan.pid, stripe_tok: nil, role: role, last4: last4)
    result[:notice] = "Subscription information updated successfully!"

    result


  # Stripe will send back CardErrors, with friendly messages
  # when something goes wrong.
  # This `rescue block` catches and displays those errors.
  rescue Stripe::CardError => e
    result[:error] = "There was an error processing your credit card information: " + e.message
    result

  rescue
    result[:error] = "There was an error updating your subscription information. Please try again."
    result
  end

  def finalize
    result = {}
    # Grab plan from User
    plan = Plan.where(pid: self.user.plan).first
    # Set one-time stripe token from User
    self.one_time_tok = self.user.stripe_tok

    if (self.one_time_tok)
      customer = self.create_customer(plan.name)
      last4 = self.get_card_last_4
      self.user.update_attributes(stripe_id: customer.id, plan: plan.pid, stripe_tok: nil, role: :premium, last4: last4)
      result[:notice] = "You have successfully sign up for for the #{plan.name.titleize} plan!"
    else
      result[:error] = "There was an error processing your credit card information. Please update your credit card information, but in the meantime enjoy our free subscription! "
      self.user.update_attributes(plan: 0, stripe_tok: nil, role: :basic)
    end

    result      

  # Stripe will send back CardErrors, with friendly messages
  # when something goes wrong.
  # This `rescue block` catches and displays those errors.
  rescue Stripe::CardError => e
    result[:error] = "There was an error processing your credit card information. Please update your credit card information, but in the meantime enjoy our free subscription! " + e.message
    self.user.update_attributes(plan: 0, stripe_tok: nil, role: :basic)
    result

  rescue
    result[:error] = "There was an error processing your credit card information. Please update your credit card information, but in the meantime enjoy our free subscription! "
    # Make sure customer goes back to the basic plan until they update their credit card info.
    self.user.update_attributes(plan: 0, stripe_tok: nil, role: :basic)
    result
  end



  def create_customer(plan_name)
    # Creates a Stripe Customer object, for associating
    # with the charge
    if one_time_tok
      Stripe::Customer.create(
        email: self.user.email,
        card: self.one_time_tok,
        plan: plan_name
      )
    else
      # Throw some error.
    end
  end

  def get_card_last_4
    # Grab customer info from stripe if they 
    if self.cust_id
      cards = Stripe::Customer.retrieve(self.cust_id).cards.all(:limit => 1)
      cards[:data][0][:last4]
    end

  # Return nil if we timeout. This should not be a fatal error.
  rescue
    nil
  end

  def retrieve_customer
    if self.cust_id
      Stripe::Customer.retrieve(self.cust_id)
    else
      # Throw some error
    end
  end

  def delete_customer
    customer = self.retrieve_customer
    customer.delete
  end

  def retrieve_subscription
    if self.cust_id
      # First retrieve Stripe account.
      customer = retrieve_customer
      # We have to get the ID of the user's subscription
      subscriptions = Stripe::Customer.retrieve(self.cust_id).subscriptions.all(:limit => 1)
      # Now we can actually retrieve the Stripe subscription.
      customer.subscriptions.retrieve(subscriptions[:data][0][:id])
    else
      # Throw some error
    end
  end

  def update_subscription(new_plan_name)
    # Get the current customer's Stripe account.
    subscription = self.retrieve_subscription
    # Update subscripiton information
    subscription.plan = new_plan_name
    subscription.card = self.one_time_tok if self.one_time_tok
    subscription.save
  end

end