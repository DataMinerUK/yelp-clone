require 'rails_helper'

feature 'reviewing' do

  let!(:restaurant) { FactoryGirl.create(:restaurant) }
  let!(:user) { FactoryGirl.create(:user) }

  before do
    login_as(user, :scope => :user)
    restaurant.reviews.create_with_user({thoughts: 'so so', rating: 2}, user)
  end

  scenario 'allows users to leave a review using a form' do
     visit '/restaurants'
     expect(current_path).to eq '/restaurants'
     expect(page).to have_content('so so')
  end

  scenario 'allows users to delete a review' do
    visit '/restaurants'
    expect{ click_link 'Delete review' }.to change { Review.count }.by(-1)
    expect(current_path).to eq '/restaurants'
    expect(page).not_to have_content('so so')
  end

  scenario 'does not allow users to delete a review they have not authored' do
    another_user = FactoryGirl.create(:user)
    login_as(another_user, :scope => :user)
    visit '/'
    expect{ click_link 'Delete review' }.not_to change{ Review.count }
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('You are not the author of this review')
  end

end
