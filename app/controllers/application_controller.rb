class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, null_session: true
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, if: :skip_authenticate_user
  skip_before_action :verify_authenticity_token, if: :skip_authenticate_user

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name bio])
  end

  def skip_authenticate_user
    (request.format.json? || request.format.xml?)
  end

  def authenticate_api_request
    return @api_user ||= current_user unless request.format.json? || request.format.xml?

    auth_token = request.headers['x-api-key'] # for now this is the user id until JWT
    @api_user = User.find_by(id: auth_token)

    return render json: { error: 'Invalid token' }, status: :unauthorized unless @api_user || request.format.html?

    @api_user
  end
end
