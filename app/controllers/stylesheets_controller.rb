class StylesheetsController < ApplicationController
  
  add_breadcrumb :root, '#'
  
  def layout
    add_breadcrumb :layout, :layout_stylesheets_path
  end
  
  def grid
    add_breadcrumb :grid, :grid_stylesheets_path
  end
  
  def button
    add_breadcrumb :button, :button_stylesheets_path
  end
  
end
