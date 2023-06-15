class HomeController < ApplicationController
    def index
        if current_user.role == "User"
            @ud = current_user.user_docs.where('extract(year from created_at) >= ? and created_at <= ? && recover = false', 2022,  DateTime.new(2022,11,15) )
            @req_dp = current_user.profile_image.attached? ? (current_user.profile_image.created_at.year >= 2022 && current_user.profile_image.created_at <= DateTime.new(2022,11,15)) ? true : false : true
            @req_doc = {"Drivers License" => "Drivers License" , "Insurance card" => "Insurance card", "CNA license" => "Healthcare Licence (RN, PT, OT, PTA, OTA, CNA)"}
            current_user.user_docs.each { |t| @req_doc.delete(t.document_type.name) if @req_doc[t.document_type.name]; }
        end
    end
end