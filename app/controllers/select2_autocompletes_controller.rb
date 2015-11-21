class Select2AutocompletesController < ApplicationController
  def search
    begin
      if params[:class_name].present?
        adapter = "::#{params[:class_name].camelize}SearchAdapter".constantize
      else
        render json: {error: "not enough search parameters'"}.to_json,
               status: 500
        return
      end
    rescue NameError
      render json: {error: "not found search adapter for '#{params[:class_name]}'"}.to_json,
             status: 500
      return
    end

    term = params.delete(:term)
    page = params.delete(:page)
    search_method = params.delete(:search_method)
    render json: adapter.search_from_autocomplete(term, page, search_method, params).to_json
  end
end