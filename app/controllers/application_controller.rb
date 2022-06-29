class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from ActionController::BadRequest, with: :bad_request
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def bad_request(exception)
    render status: :bad_request, json: {error: exception.message}.to_json
  end

  def record_not_found(exception)
    render status: :not_found, json: {error: exception.message}.to_json
  end
end
