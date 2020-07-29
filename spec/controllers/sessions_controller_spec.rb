require 'rails_helper'
require 'redis_spec_helper'

RSpec.describe SessionsController, type: :controller do

  describe "POST create" do
    before do
      CreateUser.call({ name: 'szum', password: 'Testing123!', password_confirmation: 'Testing123!'})
    end

    context "with valid attributes" do
      it "creates a new session and redirects to user show" do
        post :create, params: { session: { "name": "szum", "password": "Testing123!" } }
        expect(flash['success']).should be_present
        expect(response.status).to eq(302)
      end
    end

    context "with invalid attributes" do
      it "does not create a new session and redirects to login" do
        post :create, params: { session: { "name": "szum", "password": "invalidpassword" } }
        expect(flash['danger']).should be_present
        expect(response.status).to eq(302)
        expect(response).to redirect_to login_path
      end
    end

    describe "request via JSON" do
      context "with valid attributes" do
        it "creates a new session and renders 200 success" do
          post :create, :params => { :session => { :name => "szum", :password => "Testing123!" } }, format: :json
          expect(response.content_type).to include("application/json")
          expect(response.status).to eq(200)
        end
      end

      context "with invalid attributes in JSON" do
        it "doesn't create a new session and renders 401" do
          post :create, :params => { :session => { :name => "szum", :password => "wrongpassword" } }, format: :json
          expect(response.content_type).to include("application/json")
          expect(response.status).to eq(401)
        end
      end
    end
  end

  describe "DELETE destroy" do
    before do
      CreateUser.call({ name: 'szum', password: 'Testing123!', password_confirmation: 'Testing123!'})
    end

    context "with logged in user" do
      it "destroys the session" do
        post :create, params: { session: { "name": "szum", "password": "Testing123!" } }, format: :json
        delete :destroy
        expect(delete).to eq(200)
      end
    end
  end
end
