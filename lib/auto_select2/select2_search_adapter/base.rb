module AutoSelect2
  module Select2SearchAdapter
    class Base
      class << self
        # Amount rows per ajax-request
        def limit
          25 # TODO: move to settings/config
        end

        def search_from_autocomplete(term, page, search_method, options)
          if search_method.nil?
            search_default(term, page, options)
          else
            self.public_send("search_#{search_method}", term, page, options)
          end
        end

      private

        def default_finder(searched_class, term, options)
          columns = options[:column].present? ? options[:column] : 'name'
          conditions =
              default_search_conditions(term,
                                        options[:basic_conditions],
                                        columns,
                                        options.slice(:case_sensitive))
          if term.nil?
            [ searched_class.where(options[:basic_conditions]) ]
          else
            skip_count = 0
            unless options.nil? || options[:page].nil?
              page = options[:page].to_i > 0 ? options[:page].to_i : 1
              skip_count = limit * ( page - 1 )
            end
            query = searched_class.where( conditions ).limit( limit ).offset(skip_count).order(columns)
            query = query.select(options[:select]) if options[:select].present?
            options[:uniq] ? query.uniq : query
          end
        end

        def default_count(searched_class, term, options = {})
          conditions =
              default_search_conditions(term,
                                        options[:basic_conditions],
                                        options[:column] || 'name',
                                        options.slice(:case_sensitive))
          query = searched_class.where(conditions)
          query = query.select(options[:select]) if options[:select].present?
          query = options[:uniq] ? query.uniq : query
          query.count
        end

        def default_search_conditions(term, basic_conditions, columns, options = {})
          term_filter = ''
          conditions = []
          unless columns.is_a?(Array)
            columns = columns.split(/[\s,]+/)
          end
          unless term.nil?
            words = term.split(' ')
            # @ todo: needs to create arrays with conditions for words and columns and concatenate them in a properly way
            words.each_with_index do |word, index|
              term_filter += ' AND ' if index > 0
              term_filter += '( ' if columns.any?
              columns.each_with_index do |column, idx|
                term_filter += ' OR ' if idx > 0
                if options[:case_sensitive]
                  term_filter += "#{column} LIKE ?"
                else
                  term_filter += "LOWER(#{column}) LIKE LOWER(?)"
                end
                conditions << "%#{word}%"
              end
              term_filter += ' )' if columns.any?
            end
            term_filter = term_filter.empty? ? nil : "(#{term_filter})"
            basic_conditions_part = basic_conditions.present? ? "(#{basic_conditions }) " : nil
            conditions.unshift([term_filter, basic_conditions_part].compact.join(' AND '))
          end
        end

        def get_init_values(searched_class, ids, options = {})
          hash_method = options[:hash_method]
          text_columns = options[:text_columns] || []
          id_column = options[:id_column] || searched_class.primary_key
          ids = ids.split(',')
          if ids.size > 1
            result = []
            ids.each do |id|
              item = searched_class.where(id_column => id).first
              if item.present?
                result << get_select2_hash(item, hash_method, id_column, text_columns)
              end
            end
            result
          elsif ids.size == 1
            item = searched_class.where(id_column => ids[0]).first
            get_select2_hash(item, hash_method, id_column, text_columns) if item.present?
          else
            nil
          end
        end

        def get_select2_hash(item, hash_method, id_column, text_columns)
          if hash_method.present? && item.respond_to?(hash_method)
            item.public_send(hash_method)
          else
            if item.respond_to?(:to_select2)
              item.to_select2
            else
              label_method = text_columns.first || :name
              if item.respond_to?(label_method)
                { text: item.public_send(label_method), id: item.public_send(id_column) }
              else
                return { error: 'not found label method' }
              end
            end
          end
        end
      end
    end
  end
end
