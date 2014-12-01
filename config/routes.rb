Rails.application.routes.draw do
  get 'select2_autocompletes/(:class_name)', to: 'select2_autocompletes#search',
                                             as: 'select2_autocompletes'
end