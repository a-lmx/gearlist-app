class HomeController < ApplicationController
end

# to display list:
# => get list details
  # => get '/lists/:id'
# => get list_sections
  # => get 'lists/:id/sections'
# => for each list_section
  # => get list_section_items
    # => get 'list-sections/:id/items'
  # => subtotal section
# => calculate total weight of all list_sections_items
