class TextFragmentsController < ApplicationController
  before_filter :set_text_fragment, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user! 
  load_and_authorize_resource
  
  respond_to :html

  def index
    @text_fragments = TextFragment.all
    respond_with(@text_fragments)
  end

  def show
    respond_with(@text_fragment)
  end

  def new
    @text_fragment = TextFragment.new
    respond_with(@text_fragment)
  end

  def edit
  end

  def create
    @text_fragment = TextFragment.new(params[:text_fragment])
    @text_fragment.save
    respond_with(@text_fragment)
  end

  def update
    @text_fragment.update_attributes(params[:text_fragment])
    respond_with(@text_fragment)
  end

  def destroy
    @text_fragment.destroy
    respond_with(@text_fragment)
  end

  private
    def set_text_fragment
      @text_fragment = TextFragment.find(params[:id])
    end
end
