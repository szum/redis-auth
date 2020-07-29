require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:listing) { Fabricate(:listing_with_event) }
  let(:user) { listing.user }

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
    context "with valid attributes" do
      it "creates a new user and redirects to user show" do
        post :create, params: { user: { "name": "szum", "email": "lukas@test.org", "password": "lol", "password_confirmation": "lol" } }
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)['table']
        expect(flash['success']).should be_present
      end

      it "redirects to the new contact" do
        post :create, contact: Factory.attributes_for(:contact)
        response.should redirect_to Contact.last
      end
    end

    context "with invalid attributes" do
      it "does not save the new contact" do
        expect{
          post :create, contact: Factory.attributes_for(:invalid_contact)
        }.to_not change(Contact,:count)
      end

      it "re-renders the new method" do
        post :create, contact: Factory.attributes_for(:invalid_contact)
        response.should render_template :new
      end
    end
  end
end
