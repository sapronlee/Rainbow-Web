require 'spec_helper'

describe StylesheetsController do

  describe "GET 'layout'" do
    it "returns http success" do
      get 'layout'
      response.should be_success
    end
  end

end
