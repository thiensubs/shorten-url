# frozen_string_literal: true

require "rails_helper"

feature "Shorten URL", type: :feature do
  scenario "user create shorten URL without alias success" do
    user = FactoryBot.create(:user)
    my_link = FactoryBot.create(:my_link)
    my_link.destroy
    visit root_path
    expect(page).to have_content 'Sign in'

    click_link(href: new_user_session_path)

    within("#new_user") do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: '123456'
    end
    click_button 'Log in'
    expect(page).to have_content 'Sign out'
    expect(page).to have_content 'Manage links'
    expect(page).to have_content 'Shorten the URL in seconds'

    within("#shorten_url_form") do
      fill_in 'A url *', with: my_link.a_url
    end
    click_button 'Shorten in seconds!'
    expect(page).to have_content my_link.a_url
  end
  scenario "user create shorten URL with alias" do
    user = FactoryBot.create(:user)
    my_link = FactoryBot.create(:my_link)
    my_link.destroy

    visit root_path
    expect(page).to have_content 'Sign in'

    click_link(href: new_user_session_path)

    within("#new_user") do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: '123456'
    end
    click_button 'Log in'
    expect(page).to have_content 'Sign out'
    expect(page).to have_content 'Manage links'
    expect(page).to have_content 'Shorten the URL in seconds'

    within("#shorten_url_form") do
      fill_in 'A url *', with: my_link.a_url
      fill_in 'Alias value', with: '4a44p'
    end
    click_button 'Shorten in seconds!'
    expect(page).to have_content my_link.a_url
    expect(page).to have_content "4a44p"
  end
end