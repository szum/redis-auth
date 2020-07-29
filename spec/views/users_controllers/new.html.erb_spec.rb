require 'rails_helper'

RSpec.describe "users_controllers/new", type: :view do
  before(:each) do
    assign(:users_controller, UsersController.new())
  end

  it "renders new users_controller form" do
    render

    assert_select "form[action=?][method=?]", users_controllers_path, "post" do
    end
  end
end
