require 'rails_helper'

feature "User can sign in and out" do
  context "user not signed in and on the homepage" do
    it "should see a 'sign in' link and a 'sign up' link" do
      visit('/')
      expect(page).to have_link('Sign in')
      expect(page).to have_link('Sign up')
    end

    it "should not see 'sign out' link" do
      visit('/')
      expect(page).not_to have_link('Sign out')
    end
  end

  context "user signed in on the homepage" do
    before do
      visit('/')
      click_link('Sign up')
      fill_in('Email', with: 'test@example.com')
      fill_in('Password', with: 'testtest')
      fill_in('Password confirmation', with: 'testtest')
      click_button('Sign up')
    end

    it "should see 'sign out' link" do
      visit('/')
      expect(page).to have_link('Sign out')
    end

    it "should not see a 'sign in' link and a 'sign up' link" do
      visit('/')
      expect(page).not_to have_link('Sign in')
      expect(page).not_to have_link('Sign up')
    end
  end

  context "user making changes to restaurants" do
    scenario "can only edit restaurants they have created" do
      sign_up_user_test1
      create_restaurant_New
      click_link('Sign out')
      sign_up_user_test2
      visit('/')
      click_link('Edit New')
      restaurant_id = Restaurant.find_by(name: 'New').id
      expect(current_path).not_to eq "/restaurants/#{restaurant_id}/edit"
    end

    scenario "can only delete restaurants they have created" do
      sign_up_user_test1
      create_restaurant_New
      click_link('Sign out')
      sign_up_user_test2
      visit('/')
      click_link('Delete New')
      expect(page).not_to have_content 'Restaurant deleted successfully'
      expect(page).to have_content 'You cannot delete this restaurant'
    end

  end

  def sign_up_user_test1
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test1@example.com')
    fill_in('Password', with: 'test1test1')
    fill_in('Password confirmation', with: 'test1test1')
    click_button('Sign up')
  end

  def sign_up_user_test2
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test2@example.com')
    fill_in('Password', with: 'test2test2')
    fill_in('Password confirmation', with: 'test2test2')
    click_button('Sign up')
  end

  def create_restaurant_New
    visit '/restaurants'
    click_link 'Add a restaurant'
    fill_in 'Name', with: 'New'
    click_button 'Create Restaurant'
  end

end
