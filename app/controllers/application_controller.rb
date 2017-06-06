class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  def choose_batters
    if Record.where(selected: true).count == 0
      redirect_to '/home/choose'
    end
  end
end
