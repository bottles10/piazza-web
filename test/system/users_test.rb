require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "new user can sign up" do
    visit root_path

    click_on I18n.t("layouts.shared.navbar.sign_up")

    fill_in User.human_attribute_name(:name),
                                      with: "Newman"
    fill_in User.human_attribute_name(:email),
                                      with: "newman@example.com"
    fill_in User.human_attribute_name(:password),
                                      with: "short"

    click_on I18n.t("users.new.sign_up")
    assert_selector ("div#error_explanation"), text: I18n.t
      ("activerecord.errors.models.user.attributes.password.too_short")

    fill_in User.human_attribute_name(:password),
                                      with: "password"
    click_on I18n.t("users.new.sign_up")

    assert_current_path root_path
    assert_selector ".notification", text: I18n.t("users.create.welcome", name: "Newman")
    assert_selector "#profile", text: "Profile"
  end
end
