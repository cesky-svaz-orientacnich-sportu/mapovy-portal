# -*- encoding : utf-8 -*-
class Backend::BackendController < ApplicationController

  before_filter :require_admin

end
