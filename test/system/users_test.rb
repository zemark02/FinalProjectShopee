require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  # setup do
  #
  #
  # end
  #
  test "buy_and_create_product" do
    #
    visit "/login"
    fill_in "Username", with: "admin"
    fill_in "Password", with: "admin"
    click_on "login"
    click_on "Sell"
    fill_in "Name" , with: "admin"
    fill_in "Store name" ,with:"admin"
    fill_in "Phone" ,with:"admin"
    fill_in "Address store" ,with:"admin"
    click_on "Register"
    click_on "Sell"

    before = Product.count

    find('[data-bs-target="#showFormAddProduct"]').click
    fill_in "Name" ,with:"apple"
    fill_in "Price" ,with:"20"
    fill_in "Quantity" ,with:"200"
    fill_in "Description" ,with:"apple red"
    find('[for="product_tags_food"]').click
    find('[class="btn btn btn-modal-create-product mt-2"]').click
    after = Product.count

    assert_equal after, before + 1


    before = Product.count

    find('[data-bs-target="#showFormAddProduct"]').click
    fill_in "Name" ,with:"potato"
    fill_in "Price" ,with:"1500"
    fill_in "Quantity" ,with:"2"
    fill_in "Description" ,with:"potato"
    find('[for="product_tags_food"]').click
    find('[class="btn btn btn-modal-create-product mt-2"]').click
    after = Product.count
    assert_equal after, before + 1


    click_on "logout"
    fill_in "Username", with: "admin2"
    fill_in "Password", with: "admin2"
    click_on 'login'
    user = User.find_by_username("admin2")
    fill_in "search product" ,with:"potato"
    find('[id="btn-submit-nav-search"]').click
    find('[class="text-card-title-otherShop card-title"]').click


    before=  User.find_by_username("admin2").cart.match_products.count
    find('[class="bi-cart-plus"]').click
    after = User.find_by_username("admin2").cart.match_products.count

    assert_equal after, before + 1

    beforeOrder = Order.count
    beforeOrderLineItem = OrderLineItem.count
    click_on "Cart"
    click_on "check out"
    afterOrder = Order.count
    afterOrderLineItem = OrderLineItem.count

    assert_equal beforeOrder + 1, afterOrder
    assert_equal beforeOrderLineItem + 1 , afterOrderLineItem
  end

  test "ctrate_store" do
    visit "/login"
    fill_in "Username", with: "admin"
    fill_in "Password", with: "admin"
    click_on "login"
    click_on "Sell"
    fill_in "Name" , with: "admin"
    fill_in "Store name" ,with:"admin"
    fill_in "Phone" ,with:"admin"
    fill_in "Address store" ,with:"admin"
    click_on "Register"
    click_on "Sell"
    assert_selector "h3", text: "No have Product"
  end

  test "login_success" do
    visit "/login"
    fill_in "Username", with: "admin"
    fill_in "Password", with: "admin"
    click_on "login"
    click_on "logout"
  end




  test "login_fail" do
    visit "/login"
    fill_in "Username", with: "1"
    fill_in "Password", with: "2"
    click_on "login"
    assert_text "Username is invalid"
  end


  test "registerFail_rgeisterSuccess_buyManyProduct_comment" do

    visit "/login"

    #
    click_on "Register"
    fill_in 'Full Name' ,with: "username"
    fill_in 'Username' ,with: "username"
    fill_in 'Email' ,with: "username"
    fill_in 'Phone Number' ,with: "username"
    fill_in 'Password' ,with: "username"
    fill_in 'Comfirm Password' ,with: "username"
    fill_in 'Address' , with: "username"
    click_on "Register"
    assert_text "Username already exists"
    assert_text "Email already exists"

    fill_in 'Full Name' ,with: "username4"
    fill_in 'Username' ,with: "username4"
    fill_in 'Email' ,with: "username4"
    fill_in 'Phone Number' ,with: "username4"
    fill_in 'Password' ,with: "username4"
    fill_in 'Comfirm Password' ,with: "username5"
    fill_in 'Address' , with: "username4"
    click_on "Register"
    assert_text "Password confirmation doesn't match Password"

    before = Cart.count
    fill_in 'Full Name' ,with: "username4"
    fill_in 'Username' ,with: "username4"
    fill_in 'Email' ,with: "username4"
    fill_in 'Phone Number' ,with: "username4"
    fill_in 'Password' ,with: "username4"
    fill_in 'Comfirm Password' ,with: "username4"
    fill_in 'Address' , with: "username4"
    click_on "Register"
    assert_text "User was successfully created."
    after = Cart.count

    assert_equal after, before + 1

    before = Cart.count
    click_on "Register"
    fill_in 'Full Name' ,with: "store"
    fill_in 'Username' ,with: "store"
    fill_in 'Email' ,with: "store"
    fill_in 'Phone Number' ,with: "store"
    fill_in 'Password' ,with: "store"
    fill_in 'Comfirm Password' ,with: "store"
    fill_in 'Address' , with: "store"
    click_on "Register"
    assert_text "User was successfully created."
    after = Cart.count

    assert_equal after, before + 1

    fill_in "Username", with: "store"
    fill_in "Password", with: "store"
    click_on "login"

    click_on "Sell"
    fill_in "Name" , with: "store"
    fill_in "Store name" ,with:"store"
    fill_in "Phone" ,with:"store"
    fill_in "Address store" ,with:"store"
    click_on "Register"
    click_on "Sell"
    before = Product.count
    before_count_HasTag = HasTag.count
    before_count_tag = Tag.count
    find('[data-bs-target="#showFormAddProduct"]').click
    fill_in "Name" ,with:"apple"
    fill_in "Price" ,with:"20"
    fill_in "Quantity" ,with:"200"
    fill_in "Description" ,with:"apple red"
    find('[for="product_tags_food"]').click
    find('[class="btn btn btn-modal-create-product mt-2"]').click
    after = Product.count
    after_count_HasTag = HasTag.count
    after_count_tag = Tag.count
    assert_equal after, before + 1
    assert_equal after_count_HasTag, before_count_HasTag + 1
    assert_equal after_count_tag, before_count_tag + 1

    before = Product.count
    before_count_HasTag = HasTag.count
    before_count_tag = Tag.count

    find('[data-bs-target="#showFormAddProduct"]').click
    fill_in "Name" ,with:"potato"
    fill_in "Price" ,with:"1500"
    fill_in "Quantity" ,with:"2"
    fill_in "Description" ,with:"potato"
    find('[for="product_tags_food"]').click
    find('[class="btn btn btn-modal-create-product mt-2"]').click
    after = Product.count
    after_count_HasTag = HasTag.count
    after_count_tag = Tag.count

    assert_equal after, before + 1
    assert_equal after_count_HasTag, before_count_HasTag + 1
    assert_equal after_count_tag, before_count_tag + 1
    click_on "logout"
    #
    fill_in "Username", with: "username4"
    fill_in "Password", with: "username4"
    click_on "login"

    fill_in "search product" ,with:"potato"
    find('[id="btn-submit-nav-search"]').click
    find('[class="text-card-title-otherShop card-title"]').click

    before=  User.find_by_username("username4").cart.match_products.count
    before_contain = Contain.count
    find('[class="bi-cart-plus"]').click
    after = User.find_by_username("username4").cart.match_products.count
    after_contain = Contain.count

    assert_equal after, before + 1
    assert_equal before_contain+1, after_contain

    fill_in "search product" ,with:"potato"
    find('[id="btn-submit-nav-search"]').click
    find('[class="text-card-title-otherShop card-title"]').click

    before=  User.find_by_username("username4").cart.match_products.count
    before_contain = Contain.count
    find('[class="bi-cart-plus"]').click
    after = User.find_by_username("username4").cart.match_products.count
    after_contain = Contain.count
    assert_equal after, before + 1
    assert_equal before_contain+1, after_contain

    beforeOrder = Order.count
    beforeOrderLineItem = OrderLineItem.count
    click_on "Cart"
    click_on "check out"
    afterOrder = Order.count
    afterOrderLineItem = OrderLineItem.count

    assert_equal beforeOrder + 1, afterOrder
    assert_equal beforeOrderLineItem + 2 , afterOrderLineItem

    click_on "Profile"
    find('[id="cash-icon"]').click

    find('[class="nav-link fs-6 p-0 click-to-rate"]', match: :first).click

    rate_before = Rate.count
    fill_in "comment" , with:"comment1"
    click_on "Comment"
    rate_after = Rate.count
    assert_equal rate_before + 1, rate_after

    find('[id="cash-icon"]').click
    find('[class="nav-link fs-6 p-0 click-to-rate"]', match: :first).click
    rate_before = Rate.count
    fill_in "comment" , with:"comment2"
    click_on "Comment"
    rate_after = Rate.count
    assert_equal rate_before + 1, rate_after

    before_count_Follow = Follow.count
    fill_in "search product" ,with:"apple"
    find('[id="btn-submit-nav-search"]').click
    find('[class="text-card-title-otherShop card-title"]').click
    click_on "+ Follow"
    after_count_Follow = Follow.count
    assert_equal before_count_Follow + 1, after_count_Follow


  end












end
