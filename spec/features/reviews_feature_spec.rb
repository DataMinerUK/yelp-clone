require 'rails_helper'

feature 'reviewing' do
  before {Restaurant.create name: 'KFC'}

  scenario 'allows users to leave a review using a form' do
     sign_up_user_test1
     visit '/restaurants'
     review_KFC
     expect(current_path).to eq '/restaurants'
     expect(page).to have_content('so so')
  end

  scenario 'allows users to delete a review' do
    sign_up_user_test1
    visit '/restaurants'
    review_KFC
    expect{ click_link 'Delete review' }.to change { Review.count }.by(-1)
    expect(current_path).to eq '/restaurants'
    expect(page).not_to have_content('so so')
  end

  scenario 'does not allow users to delete a review they have not authored' do
    sign_up_user_test1
    visit '/restaurants'
    review_KFC
    click_link 'Sign out'
    sign_up_user_test2
    expect{ click_link 'Delete review' }.not_to change{ Review.count }
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('You are not the author of this review')
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

  def review_KFC
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
  end

end
