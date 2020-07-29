require 'rails_helper'
require 'redis_spec_helper'

RSpec.describe SessionsController, type: :controller do
  let!(:redis) { Redis.new }

  # describe "GET #index" do
  #   it "populates an array of contacts" do
  #     contact = Factory(:contact)
  #     get :index
  #     assigns(:contacts).should eq([contact])
  #   end

  #   it "renders the :index view" do
  #     get :index
  #     response.should render_template :index
  #   end
  # end

  # describe "GET #show" do
  #   it "assigns the requested contact to @contact" do
  #     contact = Factory(:contact)
  #     get :show, id: contact
  #     assigns(:contact).should eq(contact)
  #   end

  #   it "renders the #show view" do
  #     get :show, id: Factory(:contact)
  #     response.should render_template :show
  #   end
  # end

  describe "POST create" do
    before do
      CreateUser.call({ name: 'szum', password: 'lol', password_confirmation: 'lol'})
    end
    context "with valid attributes" do
      it "creates a new user and redirects to user show" do
        post :create, params: { session: { "name": "szum", "password": "lol" } }
        expect(flash['success']).should be_present
        expect(response.status).to eq(200)
      end
    end

    context "with invalid attributes" do
      it "does not save the new contact" do
        post :create, params: { session: { "name": "szum", "password": "invalidpassword" } }
        expect(flash['danger']).should be_present
        expect(response.status).to eq(401)
      end
    end
  end
end
