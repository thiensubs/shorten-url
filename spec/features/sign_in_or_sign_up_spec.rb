# frozen_string_literal: true

require "rails_helper"

feature "Authentication", type: :feature do
  scenario "visitor sign in success" do
    user = FactoryBot.create(:user)
    visit root_path

    expect(page).to have_content "Sign in"
    expect(page).to have_content "anvotien@gmail.com"
    click_link(href: new_user_session_path)

    within("#new_user") do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: '123456'
    end
    click_button 'Log in'
    expect(page).to have_content 'Sign out'
    expect(page).to have_content 'Manage links'
    expect(page).to have_content 'Your links'
    expect(page).to have_content 'Shorten the URL in seconds'
  end
  scenario "visitor sign up success" do
    visit root_path
    expect(page).to have_content "anvotien@gmail.com"
    expect(page).to have_content "Sign in"
    click_link(href: new_user_session_path)
    click_link(href: new_user_registration_path)

    within("#new_user") do
      fill_in 'Full name', with: 'user_name'
      fill_in 'Email', with: '1111@1111.com'
      fill_in 'Password *', with: '111111111'
      fill_in "Password confirmation", with: '111111111'
    end
    click_button 'Sign up'
    expect(page).to have_content 'Sign out'
    expect(page).to have_content 'Manage links'
  end
  scenario "visitor sign in fail" do
    user = FactoryBot.create(:user)
    visit root_path

    expect(page).to have_content "Sign in"
    expect(page).to have_content "anvotien@gmail.com"
    
    click_link(href: new_user_session_path)

    within("#new_user") do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: '1234567'
    end

    expect(page).not_to have_content 'Sign out'
    expect(page).not_to have_content 'Manage links'
  end
  scenario "visitor sign up fail" do
    visit root_path

    expect(page).to have_content "Sign in"
    expect(page).to have_content "anvotien@gmail.com"
    
    click_link(href: new_user_session_path)
    click_link(href: new_user_registration_path)

    within("#new_user") do
      fill_in 'Full name', with: 'user_name'
      fill_in 'Email', with: '1111@1111.com'
      fill_in 'Password *', with: '111111112'
      fill_in "Password confirmation", with: '111111111'
    end

    expect(page).not_to have_content 'Sign out'
    expect(page).not_to have_content 'Manage links'
  end
end