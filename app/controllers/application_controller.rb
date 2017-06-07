class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  require 'csv'
      
  def choose_batters
    if Record.where(selected: true).count == 0
      redirect_to '/home/choose'
    end
  end
  
  def need_login
    unless user_signed_in?
      redirect_to '/users/sign_in'
    end
  end
end
