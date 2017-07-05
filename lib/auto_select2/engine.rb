module AutoSelect2
  class Engine < ::Rails::Engine
    # Get rails to add app, lib, vendor to load path

    initializer :javascripts do |app|
      app.config.assets.precompile +=
          %w[auto_select2/auto_select2.js auto_select2/auto_select2_ajax.js]
    end
  end
end