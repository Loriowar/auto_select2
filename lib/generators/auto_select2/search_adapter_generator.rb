module AutoSelect2
  module Generators
    class SearchAdapterGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      class_option :destination_path,
                   type: :string,
                   default: 'app/select2_search_adapters',
                   desc: 'path where need to put generated class',
                   banner: 'lib/search_adapters'
      class_option :id_column,
                   type: :string,
                   desc: 'column of your model that will be sent to select2 as `id`',
                   banner: 'id',
                   required: true
      class_option :text_columns,
                   type: :array,
                   desc: 'columns of your model involved in search process',
                   banner: 'lastname firstname',
                   required: true
      class_option :hash_method,
                   type: :string,
                   desc: 'Method of your model that return a Hash that will be transported to select2',
                   banner: 'to_select2'

      desc 'Creates SearchAdapter classes for your models'
      def create_search_adapter
        template 'search_adapter.rb.erb',
                 "#{options[:destination_path]}/#{class_path.push(file_name).join('/')}_search_adapter.rb"
      end

      private

      def id_column
        options[:id_column]
      end

      def text_columns
        options[:text_columns].map { |c| ":#{c}" }
      end

      def hash_method
        options[:hash_method]
      end
    end
  end
end