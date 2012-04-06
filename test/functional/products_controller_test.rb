require 'test_helper'
require 'authlogic/test_case'

class ProductsControllerTest < ActionController::TestCase
  
  setup do
    activate_authlogic
    @product = products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    UserSession.create(users(:one))
    get :new
    assert_response :success
  end

  test "should create product" do
    UserSession.create(users(:one))
    assert_difference('Product.count') do
      post :create, :product => @product.attributes
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, :id => @product.to_param
    assert_response :success
  end
  
  test "should get get quote" do
    #get :get_quote, :id => @product.to_param
    #assert_select_rjs :replace, 'price_quote_results'
  end

  test "should get edit" do
    UserSession.create(users(:one))
    get :edit, :id => @product.to_param
    assert_response :success
  end

  test "should update product" do
    UserSession.create(users(:one))
    put :update, :id => @product.to_param, :product => @product.attributes
    assert_redirected_to product_path(assigns(:product))
  end

  test "should destroy product" do
    UserSession.create(users(:one))
    assert_difference('Product.count', -1) do
      delete :destroy, :id => @product.to_param
    end

    assert_redirected_to products_path
  end
end
