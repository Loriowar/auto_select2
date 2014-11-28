require 'auto_select2/version'
require 'auto_select2/helpers'
require 'auto_select2/engine'
require 'select2_search_adapter/base'

module AutoSelect2
  extend ActiveSupport::Autoload

  autoload :Select2SearchAdapter
end
