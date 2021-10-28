# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @links = if current_user
      current_user.my_links.desc(:updated_at).paginate(page: params[:page], per_page: params[:per_page] || 5)
    else
      MyLink.desc(:num_of_views).limit(100).paginate(page: params[:page], per_page: params[:per_page] || 5)
    end
    @link = MyLink.new
  end
  def show
    begin
      short_url = MyLink.find_by(short_url: params[:slug])
      if short_url
        short_url.plus_viewed
        redirect_to short_url.a_url
      else
        flash[:notice] = "Not found url"
        redirect_to root_path
      end
    rescue Exception => e
      flash[:error] = e.message
      redirect_to root_path
    end
  end
end
