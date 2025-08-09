require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should redirect to feed after successful sign up" do
    get sign_up_path
    assert_response :ok

    assert_difference [ "User.count", "Organization.count" ], 1 do 
      post sign_up_path, params: {
        user: {
          name: "John",
          email: "johndoe@mail.com",
          password: "password"
        }
      }
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_select "div.notification", text: I18n.t(".users.create.welcome", name: "John")
  end

  test "should render errors if input data is invalid" do
    get sign_up_path
    assert_response :ok

    assert_no_difference [ "User.count", "Organization.count" ] do 
      post sign_up_path, params: {
        user: {
          name: "John",
          email: "johndoe@mail.com",
          password: "pass"
        }
      }
    end

    assert_response :unprocessable_content
    assert_select "div#error_explanation", 
      text: /prevented this User from being saved/i
  end
end
