class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, null_session: true
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :authenticate_user!, if: :skip_authenticate_user
  skip_before_action :verify_authenticity_token, if: :skip_authenticate_user
  rescue_from ActiveRecord::RecordNotFound, with: :_private_record_not_found
  before_action :_private_validate_params

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

  def _private_record_not_found
    respond_to do |format|
      format.html { render 'errors/_404', locals: { value: 'The details no longer exist', header: true } }
      format.json { render json: { errors: 'The details no longer exist' }, status: :not_found }
    end
  end

  def _private_validate_params
    url_params = [(params[:user_id] || params[:id]), (params[:post_id] || params[:id]), params[:id]]
    user_id, post_id, comment_id = *url_params

    @user_id = Integer(user_id) unless user_id.nil?
    @post_id = Integer(post_id) unless post_id.nil?
    @comment_id = Integer(comment_id) unless comment_id.nil?
  rescue ArgumentError
    respond_to do |format|
      format.html { render 'errors/_404', locals: { value: 'The details no longer exist', header: true } }
      format.json { render json: { errors: 'The details no longer exist' }, status: :not_found }
    end
  end
end
