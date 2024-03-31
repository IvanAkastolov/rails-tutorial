require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: "Example user",
      email: "user@mail.com",
      password: "foobar",
      password_confirmation: "foobar"
    )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "name should be no too long" do
    @user.name = "_" * 51
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "email should be no too long" do
    @user.name = "_" * 256
    assert_not @user.valid?
  end

  test "should accept valid email addresses" do
    valid_email_addresses = %w[
      user@example.com
      USER@foo.COM
      A_US-ER@foo.bar.org
      first.last@foo.jp
      alice+bob@baz.cn
    ]

    valid_email_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{@user.email.inspect} must be valid"
    end
  end

  test "should not allow invalid email addresses" do
    invalid_email_addresses = %w[
      user@mail,com
      user_at_foo.org
      user_name@exampe
      foo@bar_baz.com
      foo@bar+baz.com
    ]

    invalid_email_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{@user.email.inspect} must be invalid"
    end
  end

  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email.upcase!

    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end
end
