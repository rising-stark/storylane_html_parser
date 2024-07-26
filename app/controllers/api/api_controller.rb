class Api::ApiController < ApplicationController
  # include Api::ExceptionsHandler
  private

  def render_error(message = 'error', status = :internal_server_error)
    render json: { message: msg }, status: status
  end

  def render_ok(data = {}, status = :ok)
    render json: data, status: status
  end

  def render_unauthorized(message)
    render_error(message:, status: :unauthorized)
  end

  def render_not_found(message)
    render_error(message:, status: :not_found)
  end

  def render_unprocessable_entity(message)
    render_error(message:, status: :unprocessable_entity)
  end
end
