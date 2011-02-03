require 'test_helper'
require 'authlogic/test_case'

class CategoriesControllerTest < ActionController::TestCase
  
  setup do
    activate_authlogic
    @category = categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:categories)
  end

  test "should get new" do
    UserSession.create(users(:one))    
    get :new
    assert_response :success
  end

  test "should create category" do
    UserSession.create(users(:one))
    assert_difference('Category.count') do
      post :create, :category => @category.attributes
    end

    assert_redirected_to category_path(assigns(:category))
  end

  test "should show category" do
    get :show, :id => @category.to_param
    assert_response :success
  end

  test "should get edit" do
    UserSession.create(users(:one))
    get :edit, :id => @category.to_param
    assert_response :success
  end

  test "should update category" do
    UserSession.create(users(:one))
    put :update, :id => @category.to_param, :category => @category.attributes
    assert_redirected_to category_path(assigns(:category))
  end

  test "should destroy category" do
    UserSession.create(users(:one))
    assert_difference('Category.count', -1) do
      delete :destroy, :id => @category.to_param
    end

    assert_redirected_to categories_path
  end
end
