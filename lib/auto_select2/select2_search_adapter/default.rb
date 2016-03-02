module AutoSelect2
  module Select2SearchAdapter
    class Default < Base
      class << self
        def search_default(term, page, options)
          if @searchable_class.blank? || @id_column.blank? || @text_columns.blank?
            raise_not_implemented
          end
          if options[:init].nil?
            default_values =
                default_finder(@searchable_class,
                               term,
                               page: page,
                               column: @text_columns,
                               case_sensitive: @case_sensitive.nil? ? options[:case_sensitive] : @case_sensitive)
            total_count =
                default_count(@searchable_class,
                              term,
                              column: @text_columns,
                              case_sensitive: @case_sensitive.nil? ? options[:case_sensitive] : @case_sensitive)
            {
                items: default_values.map do |default_value|
                  get_select2_hash(
                      default_value,
                      @select2_hash_method,
                      @id_column,
                      @text_columns
                  )
                end,
                total: total_count
            }
          else
            options[:id_column] = @id_column
            options[:text_columns] = @text_columns
            get_init_values(
                @searchable_class,
                options[:item_ids],
                options
            )
          end
        end

        private

        def searchable_class(klass)
          @searchable_class = klass
        end

        def id_column(id_column)
          @id_column = id_column
        end

        def text_columns(*column_names)
          @text_columns = column_names
        end

        def hash_method(method_sym)
          @select2_hash_method = method_sym
        end

        def case_sensitive(casi)
          @case_sensitive = casi
        end

        def raise_not_implemented
          raise NotImplementedError,
                'You need to implement your own SearchAdapter. Use: `rails generate auto_select2:search_adapter`'
        end
      end
    end
  end
end

