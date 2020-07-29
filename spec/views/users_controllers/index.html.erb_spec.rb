require 'rails_helper'

RSpec.describe "users_controllers/index", type: :view do
  before(:each) do
    assign(:users_controllers, [
      UsersController.create!(),
      UsersController.create!()
    ])
  end

  it "renders a list of users_controllers" do
    render
  end
end
