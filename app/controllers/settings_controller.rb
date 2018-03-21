class SettingsController < ApplicationController

  before_action :get_setting, only: :update

  def change
    @settings = Setting.all
  end

  def update
    if @setting.update(update_setting_params)
      flash[:notice] = I18n.t(:setting_updated_successfully, scope: [:flash, :notice])
    else
      flash[:error] = @setting.pretty_errors
    end
    redirect_to settings_change_path
  end

  private

    def get_setting
      @setting = Setting.find_by(id: params[:id])
      if @setting.nil?
        render_404
      end
    end

    def update_setting_params
      params.require(:setting).permit(:value, emails_attributes: [:id, :address, :_destroy])
    end

end
