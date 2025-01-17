# frozen_string_literal: true

# Parent Controller of other controllers
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound do |_exception|
    redirect_to root_path, alert: I18n.t('records.not_found')
  end

  rescue_from ActiveRecord::RecordInvalid do |_exception|
    redirect_to root_path, alert: I18n.t('records.update_failure')
  end
end
