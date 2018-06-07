module Entities
  class PaginationEntity < Grape::Entity
    expose :total_count
    expose :total_pages
    expose :current_page
    expose :next_page
    expose :prev_page
  end
end