class AuthoritiesController < ApplicationController

  def show

    @authority = Authority.find(Rails.application.config.namespace_prefix + params[:id].to_s)
    render json: @authority
  end
end
