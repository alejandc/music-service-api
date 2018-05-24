module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def login
    post '/authenticate', email: "test@test.com", password: 'test123'
    JSON.parse(last_response.body)['auth_token']
  end

  def generate_user
    User.last || create(:user)
  end
end
