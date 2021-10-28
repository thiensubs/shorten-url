# frozen_string_literal: true

class Api::V1::Users::SessionsController < Api::V1::ApiController
  include Devise::Controllers::Helpers
  include HomeHelper
  before_action :authenticate_user!, except: [:create]

  # after_action :handle_failed_login, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]
  protect_from_forgery unless: -> { request.format.json? }
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    begin
      user = User.find_by(email: params_login[:email])
      if user && user.valid_password?(params_login[:password])
        resource = user
        sign_in(resource_name, resource)
        return render_success('Login successfully! And User Information', resource.object_after_login)
      end
    rescue Mongoid::Errors::DocumentNotFound
      invalid_login_attempt
    end
  end

  # DELETE /resource/sign_out
  def destroy
    resource_name = current_user.class.name
    current_user.sign_out!
    sign_out(resource_name)
    render_success('Log out successfully! And Good Bye')
  end

  protected
  def invalid_login_attempt
    warden.custom_failure!
    render_error_object({ code: 401, message: 'Error with your login or password' })
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  private
    def params_login
      params.require(:user).permit(:email, :password)
    end

  #   def failed_login?
  #     (options = env["warden.options"]) && options[:action] == "unauthenticated"
  #   end
end
