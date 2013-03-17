require 'test_helper'

class NotifierTest < ActiveSupport::TestCase
  setup do
    @notifier = FactoryGirl.build(:notifier)
  end

  test "valid notifier should be valid" do
    assert @notifier.valid?
  end

  #----------------------------------------------------------------------------#
  # last_login_at:
  #---------------
  test "should be valid without a last_login_at datetime" do
    @notifier.last_login_at = nil
    assert @notifier.valid?
  end

  #----------------------------------------------------------------------------#
  # last_status_req_at:
  #--------------------
  test "should be valid without a last_status_req_at datetime" do
    @notifier.last_status_req_at = nil
    assert @notifier.valid?
  end

  #----------------------------------------------------------------------------#
  # name:
  #------
  test "should be invalid without a name" do
    @notifier.name = nil
    assert @notifier.invalid?
    assert @notifier.errors[:name].any?
  end

  test "cannot have two notifiers with the same name" do
    FactoryGirl.create(:notifier, :name => 'Notifier Name')
    @notifier.name = 'Notifier Name'
    assert @notifier.invalid?
    assert @notifier.errors[:name].any?
  end

  #----------------------------------------------------------------------------#
  # notifications:
  #---------------
  test "can associate multiple notifications with a notifier" do
    assert_difference('@notifier.notifications.size', 2) do
      2.times do
        notification = FactoryGirl.build(:notification, :notifier => @notifier)
        @notifier.notifications << notification
      end
    end
  end

  #----------------------------------------------------------------------------#
  # password:
  #----------
  test "should be invalid without a password" do
    @notifier.password = nil
    assert @notifier.invalid?
    assert @notifier.errors[:password].any?
  end

  test "should be invalid with a blank password" do
    @notifier.password = ''
    assert @notifier.invalid?
    assert @notifier.errors[:password].any?
  end

  test "should be invalid with a password less than 7 characters" do
    @notifier.password = '123456'
    assert @notifier.invalid?
    assert @notifier.errors[:password].any?
  end

  test "should be valid with a password longer than 7 characters" do
    @notifier.password = '12345678'
    assert @notifier.valid?
  end

  #----------------------------------------------------------------------------#
  # timezone:
  #----------
  test "should be invalid without a timezone" do
    @notifier.timezone = nil
    assert @notifier.invalid?
    assert @notifier.errors[:timezone].any?
  end

  #----------------------------------------------------------------------------#
  # username:
  #----------
  test "should be invalid without a username" do
    @notifier.username = nil
    assert @notifier.invalid?
    assert @notifier.errors[:username].any?
  end

  test "cannot have two notifiers with the same username" do
    FactoryGirl.create(:notifier, :username => 'mynotifier')
    @notifier.username = 'mynotifier'
    assert @notifier.invalid?
    assert @notifier.errors[:username].any?
  end

end
