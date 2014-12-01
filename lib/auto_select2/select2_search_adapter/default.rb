module AutoSelect2
  module Select2SearchAdapter
    class Default < Base
      class << self
        def search_default(term, page, options)
          begin
            default_arel = options[:default_class_name].camelize.constantize
          rescue NameError
            return {error: "not found class '#{options[:default_class_name]}'"}.to_json
          end

          if options[:init].nil?
            default_values = default_finder(default_arel, term, page: page,
                                                                column: options[:default_text_column])
            default_count = default_count(default_arel, term, column: options[:default_text_column])
            {
                items: default_values.map do |default_value|
                  { text: default_value.public_send(options[:default_text_column]),
                    id: default_value.public_send(options[:default_id_column]) }
                end,
                total: default_count
            }
          else
            get_init_values(default_arel, options[:item_ids], id_column: options[:default_id_column])
          end
        end
      end
    end
  end
end

