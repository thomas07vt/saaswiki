class SubscriptionsController < ApplicationController

  def finalize
    @user = current_user

    # I only want to be here when this is the user's first time
    if @user.sign_in_count == 1 && @user.plan != 0
      stripe_service = StripeService.new(@user.id)
      result = stripe_service.finalize
      flash[:error] = result[:error] if result[:error]
      flash[:notice] = result[:notice] unless result[:error]
    end

    redirect_to authenticated_root_path
  
  end

  def cancel
    @user = current_user
    stripe_service = StripeService.new(@user.id)
    result = stripe_service.cancel
  end

  def edit
    @user = current_user
    @plan = Plan.where(pid: @user.plan).first
    @last4 = @user.last4
  end

  def update
    @user = current_user
    newplan = Plan.where(pid: params[:plan]).first
    stripe_service = StripeService.new(@user.id, params[:stripeToken])
    result = stripe_service.update(newplan)

    flash[:error] = result[:error] if result[:error]
    flash[:notice] = result[:notice] unless result[:error]

    if flash[:error]
      redirect_to edit_subscription_path(@user)
    else
      redirect_to authenticated_root_path
    end
  end

end
