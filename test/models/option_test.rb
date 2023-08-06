require 'test_helper'

class OptionTest < ActiveSupport::TestCase
  setup do
    Option.destroy_all 
  end 
  
  def test_admin_code_default
    Option.create()
    
    assert_equal 'admin', Option.first.admin_code
  end 
  
  def test_admin_code_max_length 
    option = Option.new(admin_code: 'over_10_characters')
    assert_not option.valid?
  end 
  
  def test_generate_admin_code 
    option = Option.create()
    option.generate_admin_code(6)
    
    assert_not_equal 'admin', Option.first.admin_code
    assert_equal 6, Option.first.admin_code.length
  end 
  
  def test_unique_admin_code_team    
    prof = User.create(email: 'charles@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Charles', is_admin: true)
    Team.create(team_code: 'admin', team_name: 'Team 2', user: prof)

    option = Option.create(admin_code: 'admin')
    assert_not option.valid?
  end 
end
