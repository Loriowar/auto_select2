module AutoSelect2
  class Engine < ::Rails::Engine
    # Get rails to add app, lib, vendor to load path

    initializer :javascripts do |app|
      app.config.assets.precompile +=
          %w(auto_select2/ajax_select2.js
             auto_select2/multi_ajax_select2_value_parser.js
             auto_select2/static_select2.js
             auto_select2/custom_select2.js)
    end
  end
end