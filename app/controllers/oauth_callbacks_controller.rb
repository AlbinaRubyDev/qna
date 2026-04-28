class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    authentication_processing('Github')
  end

  def facebook
    authentication_processing('Facebook')
  end

  def twitter2
    authentication_processing('Twitter2')
  end

  private

  def authentication_processing(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
