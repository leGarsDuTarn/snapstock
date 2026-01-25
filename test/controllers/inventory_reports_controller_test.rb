require "test_helper"

class InventoryReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get inventory_reports_index_url
    assert_response :success
  end

  test "should get show" do
    get inventory_reports_show_url
    assert_response :success
  end

  test "should get new" do
    get inventory_reports_new_url
    assert_response :success
  end

  test "should get create" do
    get inventory_reports_create_url
    assert_response :success
  end

  test "should get destroy" do
    get inventory_reports_destroy_url
    assert_response :success
  end
end
