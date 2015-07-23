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
      user = FactoryGirl.create(:user)
      login_as(user, :scope => :user)
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

    before do
      user = FactoryGirl.create(:user)
      user.restaurants.create({name: 'New'})
      another_user = FactoryGirl.create(:user)
      login_as(another_user, :scope => :user)
    end

    scenario "can only edit restaurants they have created" do
      visit('/')
      click_link('Edit New')
      fill_in 'Name', with: 'Not new'
      expect{ click_button 'Update Restaurant' }.not_to change{ Restaurant.find_by(name: 'New') }
      expect(page).to have_content 'You cannot modify this restaurant'
    end

    scenario "can only delete restaurants they have created" do
      visit('/')
      expect{ click_link('Delete New') }.not_to change{ Restaurant.count }
      expect(page).not_to have_content 'Restaurant deleted successfully'
      expect(page).to have_content 'You cannot modify this restaurant'
    end

  end
  
  context 'creating reviews' do

    scenario 'should only ba able to create one review per restaurant' do
      sign_up_user_test1
      create_restaurant_New
      add_review_to_New
      expect{ add_review_to_New }.not_to change{ Review.count }
      expect(page).to have_content 'You have already reviewed this restaurant'
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

  def add_review_to_New
    visit '/restaurants'
    click_link 'Review New'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
  end

end
