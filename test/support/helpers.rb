require 'rails/test_help'

class ActiveSupport::TestCase
  def encode_credentials(username, password)
    "Basic #{Base64.encode64("#{username}:#{password}")}"
  end

  def json_response
    ActiveSupport::JSON.decode @response.body
  end

  def with_valid_user_creds(user=nil, &block)
    u = user || FactoryGirl.create(:user)
    use_auth_creds(encode_credentials(u.username, u.password), &block)
  end

  def with_valid_notifier_creds(notifier=nil, &block)
    n = notifier || FactoryGirl.create(:notifier)
    use_auth_creds(encode_credentials(n.username, n.password), &block)
  end

  def with_invalid_creds(&block)
    use_auth_creds(encode_credentials('invalid', 'bah!'), &block)
  end

  def without_auth_creds(&block)
    use_auth_creds(nil, &block)
  end

  def current_user
    @controller.current_user
  end

  def current_ability
    @controller.current_ability
  end

  def reset_current_ability!(user=nil)
    @controller.stubs(:current_ability).returns(Ability.new(user))
    @controller.current_ability
  end


  protected

  def use_auth_creds(creds, &block)
    orig_auth = @request.env['HTTP_AUTHORIZATION']
    @request.env['HTTP_AUTHORIZATION'] = creds
    if block_given?
      yield
      @request.env['HTTP_AUTHORIZATION'] = orig_auth
    end
    nil
  end
end
