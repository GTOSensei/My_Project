# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module Bookstore
  class Application < Rails::Application
    config.load_defaults 5.2
    config.time_zone = 'Kyiv'
    config.i18n.available_locales = [:en]
    config.i18n.default_locale = :en
    config.generators.system_tests = nil
  end
end
