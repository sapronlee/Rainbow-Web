class HomeController < ApplicationController
  
  def index
    add_breadcrumb :index, :root_path
  end
  
end
