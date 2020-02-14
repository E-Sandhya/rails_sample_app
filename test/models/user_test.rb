require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user = User.new(name: "Sandhya", email: "sandhya@gmail.com", password: "sandhya", password_confirmation: "sandhya")
  end
  test "should be valid" do
  	assert @user.valid?
  end
  test "name should be present" do
  	@user.name = "  "
  	assert_not @user.valid?
  end
  test "email should be present" do
  	@user.email = "  "
  	assert_not @user.valid?
  end
  test "name should not be too long" do
  	@user.name = "a"* 51
  	assert_not @user.valid?
  end
  test "email should not be too long" do
  	@user.email = "a" * 244 + "@example.com"
  	assert_not @user.valid?
  end
  test "email validation should accept vallid addresses" do 
  	valid_add = %w[user@example.com USER@foo.COM a_US-ER@bad.bar.org first.last@foo.jp alice+bob@baz.cn]
  	valid_add.each do |va_add|
  		@user.email =  va_add
  		assert @user.valid?, "#{ va_add.inspect} should be valid"
  	end
  end
  test "email validation should reject invalid addresses" do 
  	invalid_addresses = %w[user@exampe,com user_at_foo.org user.name@example. foo@bar_baz.cpm foo@bar+baz.com foo@bar..com]
  	invalid_addresses.each do |invalid_address|
  		@user.email = invalid_address
  		assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
  	end
  end
  test "email addresses should be unique" do
	duplicate_user = @user.dup
	duplicate_user.email = @user.email.upcase
	@user.save
	assert_not duplicate_user.valid?
  end
  test "email addresses should be saves as lowercase" do
	mixed_case_email = "Foo@ExAMPle.CoM"
	@user.email = mixed_case_email
	@user.save
	assert_equal mixed_case_email.downcase, @user.reload.email
  end
  test "password should be present (nonblank)" do 
	@user.password = @user.password_confirmation = " " * 6
	assert_not @user.valid?
  end 
  test "password should have a minimum length" do 
	@user.password =@user.password_confirmation = "a" * 5
	assert_not @user.valid?
  end
  test "authenticated? should return false for a user with nil digest" do
	assert_not @user.authenticated?('')
  end

end
