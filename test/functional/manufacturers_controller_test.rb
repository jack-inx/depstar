require 'test_helper'
require 'authlogic/test_case'

class ManufacturersControllerTest < ActionController::TestCase
  
  setup do
    activate_authlogic
    @manufacturer = manufacturers(:one)
  end

  test "should get index" do
    UserSession.create(users(:one))
    get :index
    assert_response :success
    assert_not_nil assigns(:manufacturers)
  end

  test "should get new" do
    UserSession.create(users(:one))
    get :new
    assert_response :success
  end

  test "should create manufacturer" do
    UserSession.create(users(:one))
    assert_difference('Manufacturer.count') do
      post :create, :manufacturer => @manufacturer.attributes
    end

    assert_redirected_to manufacturer_path(assigns(:manufacturer))
  end

  test "should show manufacturer" do
    UserSession.create(users(:one))
    get :show, :id => @manufacturer.to_param
    assert_response :success
  end

  test "should get edit" do
    UserSession.create(users(:one))
    get :edit, :id => @manufacturer.to_param
    assert_response :success
  end

  test "should update manufacturer" do
    UserSession.create(users(:one))
    put :update, :id => @manufacturer.to_param, :manufacturer => @manufacturer.attributes
    assert_redirected_to manufacturer_path(assigns(:manufacturer))
  end

  test "should destroy manufacturer" do
    UserSession.create(users(:one))
    assert_difference('Manufacturer.count', -1) do
      delete :destroy, :id => @manufacturer.to_param
    end

    assert_redirected_to manufacturers_path
  end
end
