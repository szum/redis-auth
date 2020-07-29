require 'rails_helper'

RSpec.describe "users_controllers/edit", type: :view do
  before(:each) do
    @users_controller = assign(:users_controller, UsersController.create!())
  end

  it "renders the edit users_controller form" do
    render

    assert_select "form[action=?][method=?]", users_controller_path(@users_controller), "post" do
    end
  end
end
