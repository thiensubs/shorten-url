# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET index" do
    it "assigns my_links" do
      list = FactoryBot.create_list(:my_link, 40)
      get root_path(per_page: 30)

      expect(assigns(:links).present?).to eq(true)
      expect(assigns(:links).size).to eq(WillPaginate.per_page)
    end

    it "renders the index template" do
      get root_path
      expect(response).to be_successful 
      expect(response).to render_template("index")
    end
  end
end
