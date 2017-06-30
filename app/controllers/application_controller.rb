class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_login, :init

  def init
    @controller = params[:controller]
    if not %w(site user_sessions).include?(@controller)
      @object_name = @controller.singularize
      @model = @controller.singularize.split('/').map {|c| c.capitalize}.join('::').constantize if @controller
      @object = @model.find_by_id(params[:id]) if (params[:id] && @model)
    end
  end

end
