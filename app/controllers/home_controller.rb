class HomeController < ApplicationController
    def index
        @ud = current_user.user_docs.where('extract(year  from created_at) >= ?', 2022)
    end
end
