# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Shorten URL", type: :request do
  let(:my_link) {FactoryBot.create(:my_link)}
  let(:user) {FactoryBot.create(:user)}
  it "creates a shorten link and redirects to the root page" do
    sign_in user
    get new_my_link_path
    expect(response).to render_template(:new)
    
    link = MyLink.find(my_link.id)
    my_link.destroy
    post my_links_path, params: { my_link: {a_url: link.a_url} }
    expect(response).to redirect_to(root_path)
    follow_redirect!
    expect(response).to render_template(:index)
  end

  it "does not render a different template" do
    sign_in user
    get new_my_link_path
    expect(response).to_not render_template(:show)
  end
  it "this feature need authentication" do
    get new_my_link_path
    expect(response).to redirect_to(root_path)
  end
end
