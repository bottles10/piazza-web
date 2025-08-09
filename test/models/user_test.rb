require "test_helper"

class UserTest < ActiveSupport::TestCase
	test "requires a name" do
		@user = User.new(
			name: "", 
			email: "johndoe@mail.com",
			password: "password"
		)
		assert_not @user.valid?
		
		@user.name ="John"
		assert @user.valid?
	end

	test "requires a valid email" do
		@user = User.new(
			name: "John", 
			email: "",
			password: "password"
		)
		assert_not @user.valid?

		@user.email ="invalid"
		assert_not @user.valid?

		@user.email = "johndoe@mail.com"
		assert @user.valid?
	end

	test "requires a unique email" do
		@existing_user = User.create(
			name: "John", 
			email: "johndoe@mail.com",
			password: "password"
		)
		assert @existing_user.persisted?

		@user = User.new(name: "John", email: "johndoe@mail.com")
		assert_not @user.valid?
	end

	test "name and email is stripped of space before saving" do
		@user = User.create(
			name: " John ",
			email: " johndoe@mail.com "
		)

		assert_equal "John", @user.name
		assert_equal "johndoe@mail.com", @user.email
	end

	test "password must be between 8 and activeModel's maximum" do
		@user = User.new(
			name: "John",
			email: "johndoe@mail.com",
			password: ""
		)

		assert_not @user.valid?

		@user.password = "password"
		assert @user.valid?

		max_length = ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
		@user.password = "a" * (max_length + 1)
		assert_not @user.valid?
	end
end
