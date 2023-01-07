class HomeController < ApplicationController
    def index
        if current_user.role == "User"
            @ud = current_user.user_docs.where('extract(year  from created_at) >= ?', 2022)
            @req_dp = current_user.profile_image.attached? ?  current_user.profile_image.created_at.year >= 2022 ? true : false : true
            @req_doc = ["Drivers License", "Insurance card"]
            current_user.user_docs.each { |t| @req_doc.delete(t.document_type.name) unless @req_doc.include?(t.document_type.name) }
        end
    end
end