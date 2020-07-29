require 'rails_helper'

RSpec.describe "users_controllers/show", type: :view do
  before(:each) do
    @users_controller = assign(:users_controller, UsersController.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
