# -*- encoding : utf-8 -*-
class Backend::TextsController < Backend::BackendController

  skip_before_action :require_admin, only: [:locale]

  def locale
    @texts = {}
    Text.order(:name).each do |t|
      @texts[t.name] = t.send(:"body_#{I18n.locale}")
    end
  end

  def index
    @texts = Text.order(:name)
  end

  def new
    @text = Text.new
  end

  def edit
    @text = Text.find(params[:id])
  end

  def create
    @text = Text.create(params[:text])
    redirect_to :action => :index
  end

  def update
    @text = Text.find(params[:id])
    @text.update(params[:text])
    redirect_to :action => :index
  end

  def destroy
    respond_to do |format|
      format.html do
        redirect_to :action => :index
      end
    end
  end

end
