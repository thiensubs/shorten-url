# frozen_string_literal: true
require 'devise/jwt/test_helpers'
require 'rails_helper'

RSpec.describe Api::V1::MyLinksController do  
  describe "GET index of Shorten API without Authentication" do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    before do
      get api_v1_my_links_path, headers: headers
    end    
    it "returns http not success" do
      expect(response).to have_http_status(:unauthorized)
    end    
  end

  describe "GET index of Shorten API with Authentication" do
    before do
      user = FactoryBot.create(:user)
      list = FactoryBot.create_list(:my_link, 20)
      10.times.each {|e| FactoryBot.create(:my_link, user: user) }
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      # This will add a valid token for `user` in the `Authorization` header
      auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
      get api_v1_my_links_path, headers: auth_headers
    end    
    it "returns http success" do
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:success)
    end

    it "returns correct data" do
      output = JSON.parse(response.body)
      expect(output['result']['code']).to eq(200)
      expect(output['data'].first.size).to eq(10)
      expect(output['data'].last.first['total_items']).to eq(10)
    end    
  end

  describe "POST create of Shorten API with Authentication" do
    before do
      user = FactoryBot.create(:user)
      link_temporary = FactoryBot.create(:my_link)
      link_temporary.destroy
      4.times.each {|e| FactoryBot.create(:my_link, user: user) }
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      # This will add a valid token for `user` in the `Authorization` header
      auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
      post api_v1_my_links_path, headers: auth_headers, :params => '{ "my_link": { "a_url": "'+link_temporary.a_url+'"} }'
    end    
    it "returns http success" do
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:success)
    end

    it "returns correct data" do
      output = JSON.parse(response.body)
      expect(output['result']['code']).to eq(200)
      expect(output['data'].first.size).to eq(1)
      expect(output['data'].first['mylink']['alias_value']).to eq("")
      expect(output['data'].first['mylink']['num_of_views']).to eq(0)
    end    
  end
end
