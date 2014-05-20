class RegistrationsController < Devise::RegistrationsController
  def new
    build_resource({})

    planid = params[:plan].to_i || 0

    if !Plan.where(pid: planid).any?
      @plan = Plan.where(pid: 0).first
    else
      @plan = Plan.where(pid: planid).first
    end

    respond_with self.resource

  end

  def create
    @sign_up_params = sign_up_params
    build_resource(sign_up_params)

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      if (resource[:plan])
        @plan = Plan.where(pid: resource[:plan]).first
      else
        @plan = Plan.where(pid: 0).first
      end
      respond_with resource
    end
  end

  def update
    super
  end
end 