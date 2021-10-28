class CustomFailure < Devise::FailureApp
  include Devise::Controllers::Helpers
  alias_method :devise_sign_in, :sign_in 
  def redirect_url 
    if warden_options[:scope] == :user 
      if params.dig(:user,:username).present? && params.dig(:user, :password).present?
        user  = User.find_by(username: params[:username]) rescue nil
        unless user
          params_user = ActionController::Parameters.new({
            user: {
              username: params.dig(:user,:username),
              password: params.dig(:user, :password)
            }
          })

          permitted = params_user.require(:user).permit(:username, :password)
          user = User.new(permitted)
          if user.valid?
            user.save
            flash.clear()
            flash[:notice] = I18n.t('devise.sessions.signed_in')
            devise_sign_in(:user, user)
          else
            msg = user.errors.full_messages
            flash.clear()
            flash[:alert] = msg
          end
        end
      end
      root_path 
    else 
      new_admin_user_session_path 
    end 
  end 
  def respond 
    if http_auth? 
      http_auth 
    else 
      redirect 
    end 
  end 
end 