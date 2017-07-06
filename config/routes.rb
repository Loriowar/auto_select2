# frozen_string_literal: true

Rails.application.routes.draw do
  get 'select2_autocompletes/(:adapter)',
      to: 'select2_autocompletes#search',
      as: 'select2_autocompletes'
end