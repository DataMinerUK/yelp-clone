require 'rails_helper'

feature 'restaurants' do

  let(:user) { FactoryGirl.create(:user) }

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before { Restaurant.create(name: 'KFC') }

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      login_as(user, :scope => :user)
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'a user has to be logged in' do
      visit '/'
      click_link 'Add a restaurant'
      expect(current_path).not_to eq '/restaurants/new'
    end

    context 'an invalid restaurant' do
      it 'does not let you submit a name that is too short' do
        login_as(user, :scope => :user)
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'viewing restaurants' do

    let(:kfc){ FactoryGirl.create(:restaurant)}
    before { kfc }

    scenario 'lets a user view a restaurant' do
     visit '/restaurants'
     click_link 'KFC'
     expect(page).to have_content 'KFC'
     expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'user has created KFC' do

    before { user.restaurants.create({name: 'KFC'}) }

    context 'editing restaurants' do

      scenario 'let a user edit a restaurant they have created' do
         login_as(user, :scope => :user)
         visit '/restaurants'
         click_link 'Edit KFC'
         fill_in 'Name', with: 'Kentucky Fried Chicken'
         click_button 'Update Restaurant'
         expect(page).to have_content 'Kentucky Fried Chicken'
         expect(current_path).to eq '/restaurants'
      end
    end

    context 'deleting restaurants' do

      scenario 'removes a restaurant when a user clicks a delete link' do
        login_as(user, :scope => :user)
        visit '/restaurants'
        click_link 'Delete KFC'
        expect(page).not_to have_content 'KFC'
        expect(page).to have_content 'Restaurant deleted successfully'
      end
    end

  end

end
