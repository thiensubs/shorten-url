# frozen_string_literal: true

class Api::V1::Users::RegistrationsController < Api::V1::ApiController
  include Devise::Controllers::Helpers
  # before_action :configure_sign_up_params, only: [:create]
  protect_from_forgery unless: -> { request.format.json? }
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    return super unless request.format.json?
    user = User.new(params_sign_up)
    if user.save
      sign_in(user.class.name.downcase, user)
      render_success('Created account successfully! And User Infomation', user.object_after_login)
    else
      warden.custom_failure!
      render_error_object({ code: 422, message: 'Error with create account!' }.merge({ errors: user.errors.messages }))
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  private
  def params_sign_up
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation)
  end
end
