require 'rails_helper'
require 'redis_spec_helper'

RSpec.describe UsersController, type: :controller do
  # describe "GET show" do
  #   context "with no session" do
  #     get :show, id: 1

  #   end
  # end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new user and redirects to user show" do
        post :create, params: { user: { "name": "szum", "password": "Testing123!", "password_confirmation": "Testing123!" } }
        expect(flash['success']).to include("You've successfully created an account!")
        expect(response.status).to eq(302)
      end
    end

    context "with a user name that's taken" do
      it "does not save the new user" do
        CreateUser.call({ name: 'szum', password: 'Testing123!', password_confirmation: 'Testing123!'})
        post :create, params: { user: { "name": "szum", "password": "Testing123!", "password_confirmation": "Testing123!" } }
        expect(flash['danger']).to include("Username is taken. Type in a username that's unique.")
        expect(response).to redirect_to signup_path
      end
    end

    context "with invalid password that has no uppercase" do
      it "does not save the new contact" do
        post :create, params: { user: { "name": "szum", "password": "testing!", "password_confirmation": "testing!" } }
        expect(flash['danger']).to include('Password must contain at least one uppercase letter')
        expect(response).to redirect_to signup_path
      end
    end

    context "with invalid password that has no special character" do
      it "does not save the new contact" do
        post :create, params: { user: { "name": "szum", "password": "Testing123", "password_confirmation": "Testing123" } }
        expect(flash['danger']).to include('Password must contain at least one special character.')
        expect(response).to redirect_to signup_path
      end
    end

    context "with invalid password that has no digits" do
      it "does not save the new contact" do
        post :create, params: { user: { "name": "szum", "password": "Testing", "password_confirmation": "Testing" } }
        expect(flash['danger']).to include('Password must contain at least one digit.')
        expect(response).to redirect_to signup_path
      end
    end

    context "with password confirmation that does not match" do
      it "does not save the new contact" do
        post :create, params: { user: { "name": "szum", "password": "Testing123!", "password_confirmation": "Testing" } }
        expect(flash['danger']).to include('Your password confirmation does not match your password.')
        expect(response).to redirect_to signup_path
      end
    end

    context "with blank password" do
      it "does not save the new contact" do
        post :create, params: { user: { "name": "szum", "password": "", "password_confirmation": "Testing" } }
        expect(flash['danger']).to include('Your password is blank.')
        expect(response).to redirect_to signup_path
      end
    end
  end
end
