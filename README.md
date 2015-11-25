# AutoSelect2

Gem provide API (scripts, helpers, controller and base class for ajax-search)
for initialize different select2 elements: static, ajax and multi-ajax.

The `AutoSelect2` based on [select2-rails](https://github.com/argerim/select2-rails) gem.

[![Gem Version](https://badge.fury.io/rb/auto_select2.png)](http://badge.fury.io/rb/auto_select2)

## Installation

### First

Install [select2-rails](https://github.com/argerim/select2-rails#install-select2-rails-gem)
and include javascript and stylesheet assets as
[described](https://github.com/argerim/select2-rails#include-select2-rails-javascript-assets)
on `select2-rails` page.

### Second

Add this line to your application's Gemfile:

    gem 'auto_select2'

And then execute:

    $ bundle

### Third

Select one of ways to include js in pipeline. Ways described below in section `Javascript include variants`

### Fourth

Check controller and route collation. Gem contain controller `Select2AutocompletesController` and
route

    get 'select2_autocompletes/:class_name'

### Fifth

Prepare folder `app/select2_search_adapter` if you want to use `ajax-select2`. This folder needed
for storage custom `SearchAdapter`.

## Compatibility

Gem tested and works in Rails 3.2 and Rails 4.0. You can test compatibility with other versions by yourself.

## Easiest way to use

Use [AutoSelect2Tag](https://github.com/Loriowar/auto_select2_tag). It provide helpers:

* select2_tag
* select2_ajax_tag

and you can define select2 element like any other view elements in rails.

## Example

You can find example project [here](https://github.com/Loriowar/auto-select2_tag_example).

## Usage

### Element types

Gem provides 3 types of select2 elements:

* static
* ajax
* multi-ajax

For each of it exist javascript initializer. This is:

* static_select2.js
* ajax_select2.js
* multi_ajax_select2_value_parser.js

**Note:** `multi_ajax_select2_value_parser.js` work only together with `ajax_select2.js`

### Javascript include variants

You have two ways to include javascript files. First: in gem presents helper methods

* static_select2_init_header_tags
* ajax_select2_init_header_tags
* ajax_multi_select2_init_header_tags

These helpers call `javascript_include_tag` and it is useful for initialize select2
scripts on a single page. Example of usage in a view:

    - static_select2_init_header_tags
    
    %div
      = select2_tag :my_select, my_options_for_select, class: 'small'

Second variant: include files in javascript assets. For this add the
following to your `app/assets/javascripts/application.js`:

    //= require auto_select2/static_select2
    //= require auto_select2/ajax_select2
    //= require auto_select2/multi_ajax_select2_value_parser

### Select2 options

If you want to specify any parameters for [select2 constructor](http://ivaynberg.github.io/select2/)
you can pass it as hash into data-attribute `s2-options`. This parameter handle most options
but you can't pass through js-functions.

### Static select2 usage

For initialize static select2 you must set `auto-static-select2` css-class for select element:

    = select_tag :my_select, my_options_for_select, class: 'my-class auto-static-select2'

### Ajax select2 usage

For initialize ajax select 2 you must set `auto-ajax-select2` css-class for hidden-input element.
Then you need to create a `SearchAdapter`. This adapter has following requirements:

* class must be inherited from `AutoSelect2::Select2SearchAdapter::Base`
* file must be put in any folder which included into autoload path, preferably in `app/select2_search_adapter`
* name of a adapter class must end with `SearchAdapter`
* must has function `search_default(term, page, options)`
  (description of the function and return value goes below)

Returned value of `search_default` function must be follow:

* if options contain `:init` key function must return hash
  `{text: 'displayed text', id: 'id_of_initial_element'}`
* otherwise function must return the follow hash:


    { items:
      [
        { text: 'first element', id: 'first_id' },
        { text: 'second element', id: 'second_id' }
      ],
      total: count
    }

Here in "total" must be specified amount of all select variants. For example you have select
element with 42 variants. Function `search_default` return part of it in `items` and in
`total` each time you must set 42.

**TIP:** in `search_default` you can use functions from `AutoSelect2::Select2SearchAdapter::Base`:

* `default_finder(searched_class, term, options)`
* `default_count(searched_class, term, options = {})`
* `get_init_values(searched_class, ids, title_method=nil)`

More about this function you can find in [example project](https://github.com/Loriowar/auto-select2_tag_example),
in example below and in source code.

Finally hidden-input must has `:href` parameter in data-attribute `s2-options`. This
parameter specify url for ajax load select options. You can use path-helper `select2_autocompletes_path` for this purpose.

### Example of minimalistic SearchAdapter

    class SystemRoleSearchAdapter < AutoSelect2::Select2SearchAdapter::Default
      searchable_class SystemRole
      id_column :id
      text_columns: :name
      hash_method :to_select2 # optional
    end

More complex example:

    class SystemRoleSearchAdapter < AutoSelect2::Select2SearchAdapter::Base
      class << self
        def search_default(term, page, options)
          if options[:init].nil?
            roles = default_finder(SystemRole, term, page: page)
            count = default_count(SystemRole, term)
            {
              items: roles.map do |role|
                { text: role.name, id: role.id.to_s } # here is optional parameter 'class_name'
              end,
              total: count
            }
          else
            get_init_values(SystemRole, options[:item_ids])
          end
        end
      end
    end

### Generator

Gem provide a rails generator for creating a simple SearchAdapter like a first one from previous section. Run follows command:

    rails generate auto_select2:search_adapter TargetModelName --id-column=name_of_id_column  --text-columns=name_of_columns_for_searching_by

Available options for generator:
* id-column - name of model column with identifier;
* text-columns - column for searching by (available multiple values, for example "--text-columns=name description" without coma);
* hash-method - instance method of model for converting into Hash for transporting into select2 (optional);
* destination-path - path for storing SearchAdapter classes (optional, default: 'app/select2_search_adapters').

### More about SearchAdapter

`SearchAdapter` has some additional functions. First, you can define multiple search
functions in one adapter. For example in adapter for User you want to find among all
users, find users only in one department and so on. For this purpose define methods like

    def search_unusual_case(term, page, options)
      # must has same behavior as search_default
    end

near the `search_default` in `SearchAdapter`. Requirement for non-default search methods:

* it must has same behavior as search_default
* name of methods must start with `search_`

For use custom searcher specify it into `:href` within data-attribute `s2-options`:

    select2_autocompletes_path(class_name: MyClassName, search_method: :unusual_case)

Second, you may want to pass additional parameters in `SearchAdapter`. For example
select options depend from another field on page. For this purpose you can specify

    additional_ajax_data: {selector: 'input.css-class'}

inside data-attribute `s2-options`. In this case in options of `SearchAdapter` appear
additional values. It construct from name and value of html-elements. Example:

    = hidden_field_tag 'token', 'VUBJKB23UIVI1UU1VOBVI@', class: 'add-to-select2'
    = hidden_field_tag 'select2element', '',
                        class: 'auto-ajax-select2',
                        data: {s2-options: { href: select2_autocompletes_path(class_name: :adapter_name,
                                                                             search_method: :unusual_case),
                                            additional_ajax_data: {selector: '.add-to-select2'}}}

Here we initialize ajax select2 and during load select variants in `SearchAdapter` options hash
appear key :token with value 'VUBJKB23UIVI1UU1VOBVI@'.

Moreover you may pass name of js function into additional_ajax_data:

    additional_ajax_data: {selector: 'input.css-class',
                           function: 'additionalGlobalJsFunctionForRequestParameters'}

In this case function `additionalGlobalJsFunctionForRequestParameters` must looks follows:

    window.additionalGlobalJsFunctionForRequestParameters = function($element, $term) {
    
      // any js actions
    
      return {
        additional_param: '42',
        awesome_option: 'something especial'
      };
    }

As you see, function receive two arguments: select2_element (i.e. initial input field) and
term (i.e. text from input). Return value of the function must be a hash. This hash merged into
ajax data and can be obtained in `SearchAdapter`.

Third, in hash with items from search method exist additional optional parameter `class_name`.
This parameter specify css-class for result element in select2. It useful for show different
icons for different select variants.

### Multi ajax select2 usage

This feature require absolutely same things as ajax select2. Additionally you must
add `multiple` css-class for input element, doesn't forget about
`multi_ajax_select2_value_parser.js` script and pass `multiple: true` into
data-attribute `s2-options`.

### Different multi ajax select2

Honestly speaking you can just pass `multiple: true` into data-attribute `s2-options` and
ajax-select2 become multiple. But in this case selected options from select2 become as
comma separated string. As opposed to it `multi_ajax_select2_value_parser.js` make array
of multiple ids. This is more comfortable for use in controller.

### Initializing

Scripts automatically initialize on `$(document).ready()` and after `ajaxSuccess`. Moreover
script handle [cocoon](https://github.com/nathanvda/cocoon) events and run on
`cocoon:after-insert`. If you for any reasons want to manually initializing select2,
you can call `initAutoAjaxSelect2()` and/or `initAutoStaticSelect2()`.

## Contributing

1. Fork it ( http://github.com/Loriowar/auto_select2/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
