require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  describe "GET #ayuda" do
    it "returns http success" do
      get :ayuda
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #contacto" do
    it "returns http success" do
      get :contacto
      expect(response).to have_http_status(:success)
    end
  end

end
