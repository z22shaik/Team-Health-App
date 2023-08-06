require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.new(email: 'charles@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles')
    @user.save
  end
    
  def test_get_login
    get login_url
    assert_response :success
  end
    
  def test_login_professor
    post '/login',
        params: {email: 'msmucker@gmail.com', password: 'professor'}
    assert_template :new
  end
 
  def test_login_logout
    post '/login',
        params: {email: 'charles@gmail.com', password: 'banana'}
    assert_redirected_to root_url
    get '/logout'
    assert_redirected_to root_url
  end
  
  def test_wrong_password
     post '/login',
      params: {email: 'charles@gmail.com', password: 'wrong_password'}
     assert_template :new
  end

  test "update user not logged in" do
    patch user_url(@user), params: { user: { email: @user.email, name: @user.name, password: @user.password } }
    assert_redirected_to '/login'
  end

  test "edit user not logged in" do
    get edit_user_url(@user)
    assert_redirected_to '/login'
  end
  
  test "show user not logged in" do
    get user_url(@user)
    assert_redirected_to '/login'
  end
  
  test "delete user not logged in" do
    delete user_url(@user)
    assert_redirected_to '/login'
  end
end
