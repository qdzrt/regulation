module V1
  class BaseAPI < Grape::API
    format :json
    prefix :api
    version 'v1', using: :path

    include APIExtensions
    include SharedParams

    mount AuthAPI
    mount UserAPI
    mount ProductAPI
    mount CreditEvalAPI
    mount LoanFeeAPI

    helpers do
      def pagination(collection)
        {
          total_count: collection.total_count,
          total_pages: collection.total_pages,
          current_page: collection.current_page,
          next_page: collection.next_page,
          prev_page: collection.prev_page
        }
      end
    end

    if Rails.env.development?
      before do
        header['Access-Control-Allow-Origin'] = '*'
        header['Access-Control-Request-Method'] = '*'
      end

      add_swagger_documentation(
        api_version: 'v1',
        base_path: "/",
        hide_documentation_path: true,
        hide_format: true
      )
    end
  end
end