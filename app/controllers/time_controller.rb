class TimeController < ApplicationController
  def index
    data = ::Times::TimeService.new(params: params).perform
    render json: data
  end
end
