# frozen_string_literal: true

class MyLinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_link, only: [:edit, :update, :destroy]
   def index
    @links = current_user.my_links.desc(:updated_at).paginate(page: params[:page], per_page: params[:per_page] || 10)
  end
  
  def new
    @link = MyLink.new
  end

  def create
    @link = MyLink.new(params_my_link)
    if params_my_link[:alias_value].present?
      @link.short_url = params_my_link[:alias_value]
    end
    @link.user = current_user
    if @link.save
      flash[:notice] = "Record added! Shorten url DONE!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @link.update_attributes(params_my_link.merge(short_url: params_my_link[:alias_value]))
    if @link.save
      flash[:notice] = "Record updated!"
      redirect_to my_links_path
    else
      render 'edit'
    end
  end

  def destroy
    if @link.destroy
      flash[:notice] = "Record destroyed!"
    else
      flash[:notice] = "Record can not destroyed!"
    end
    redirect_to my_links_path
  end

  private
  def params_my_link
    params.require(:my_link).permit(:a_url, :alias_value)
  end
  def set_link
    @link ||= MyLink.find(params[:id])
  end
end
