# frozen_string_literal: true

AutoSelect2AdapterNotFound = Class.new(StandardError)
AutoSelect2AdapterNotDefined = Class.new(StandardError)

class Select2AutocompletesController < ApplicationController
  rescue_from AutoSelect2AdapterNotFound, with: :render_wrong_adapter
  rescue_from AutoSelect2AdapterNotDefined, with: :render_missing_adapter

  def search
    term = params.delete(:term)
    page = params.delete(:page)
    render json: find_adapter.search(term, page, **params.symbolize_keys)
  end

  private

  def find_adapter
    raise AutoSelect2AdapterNotDefined if params[:adapter].blank?

    Object.const_get("#{params[:adapter].camelize}SearchAdapter")
  rescue NameError
    raise AutoSelect2AdapterNotFound, params[:adapter]
  end

  def render_wrong_adapter
    render json: {error: "wrong adapter: '#{params[:class_name]}'"},
           status: 422
  end

  def render_missing_adapter
    render json: {error: 'adapter not defined'},
           status: 422
  end
end