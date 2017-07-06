# frozen_string_literal: true

module AutoSelect2
  module Select2SearchAdapter
    # Inspired by awesome 'uber' gem
    module InheritableAttr
      private

      def inheritable_attr(name)
        instance_eval %{
          def #{name}=(v)
            @#{name} = v
          end

          def #{name}
            return @#{name} if instance_variable_defined?(:@#{name})
            @#{name} = inherit_for(:#{name})
          end
        }
      end

      def inherit_for(name)
        return unless superclass.respond_to?(name)
        value = superclass.__send__(name)
        if unclonable?(value)
          value
        else
          value.clone
        end
      end

      def unclonable?(value)
        unclonable_classes = [Symbol, TrueClass, FalseClass, NilClass, Integer]
        unclonable_classes.any? { |k| value.is_a?(k) }
      end
    end

    class Base
      extend InheritableAttr

      inheritable_attr :searchable
      inheritable_attr :searchable_columns
      inheritable_attr :limit

      self.limit = 25

      class << self
        def search(term, page, **options)
          page ||= 1
          list = find(term, page, **options)
          total_count = count(term, **options)

          {
            results: format_list(list, **options),
            more: total_count > (page * limit)
          }
        end

        def format_list(list, **options)
          list.map { |item| format(item, **options) }
        end

        def formatted_item(id, **options)
          item = searchable.find_by(searchable.primary_key => id)
          format(item, **options) if item.present?
        end

        def format(item, **)
          {id: item.id, text: item.to_s}
        end

        def find(term, page, **options)
          if limit&.positive?
            offset = offset(page)
            relation(term, **options).order(order).offset(offset).limit(limit)
          else
            relation(term, **options).order(order)
          end
        end

        def offset(page)
          page = page ? page.to_i : 1
          limit * (page - 1)
        end

        def order
          "#{searchable.table_name}.#{searchable.primary_key} desc"
        end

        def count(term, **options)
          relation(term, **options).count
        end

        def relation(term, **)
          searchable.where(conditions(term))
        end

        def conditions(term)
          words = term.to_s.split(' ')
          return if words.blank?

          words.each_with_object([]) do |word, binds|
            searchable_columns.count.times { binds << "%#{word}%" }
          end.unshift("(#{query(words.count)})")
        end

        def query(count)
          Array.new(count, " (#{column_filters}) ").join(' AND ')
        end

        def column_filters
          searchable_columns.map do |column|
            "LOWER(#{column}) LIKE LOWER(?)"
          end.join(' OR ')
        end
      end
    end
  end
end
