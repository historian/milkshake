# vim: set ft=ruby:
require File.expand_path("../config/environment", __FILE__)

use Rails::Rack::Static
run ActionController::Dispatcher.new
