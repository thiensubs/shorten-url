# frozen_string_literal: true

class Api::V1::ApiController < Api::BaseApiController
  # rescue_from StandardError, :with => :render_500

  rescue_from ActionController::ParameterMissing, with: :missing_params
  rescue_from 'Mongoid::Errors::DocumentNotFound' do |exception|
    render_error_custom(401, 'Not found!')
  end

  def render_500(exception)
    @exception = exception
    render json: JSON.dump({
                           data: {},
                           result:
        {
          code: 500,
          message: exception.message
        }
                         }), status: :internal_server_error
  end

  protected

  def render_error(error_type, message, status_code = 200)
    render json: JSON.dump({
                           data: {},
                           result:
        {
          code: Constants::ERROR_CODES[error_type.to_sym],
          message: message
        }
                         }), status: status_code
  end

  def render_error_custom(error_type, message, status_code = 200)
    render json: JSON.dump({
                           data: {},
                           result:
        {
          code: error_type,
          message: message
        }
                         }), status: status_code
  end

  def render_error_object(object)
    render json: JSON.dump({
                           data: {},
                           result: object
                         }), status: :ok
  end

  def render_success(message, data = {}, status_code = 200)
    render json: JSON.dump({
                           data: data,
                           result: {
                             code: status_code,
                             message: message
                           }
                         }), status: :ok
  end

  def render_error_unknown
    render_error('unknown', 'Unknown')
  end

  def missing_params(e)
    render json: JSON.dump({
                           data: {},
                           result: {
                             code: 997,
                             message: e.message
                           }
                         }), status: :ok
  end

  def error_connect_redis(e)
    render json: JSON.dump({
                           data: {},
                           result: {
                             code: 500,
                             message: e.message
                           }
                         }), status: :ok
  end
end
