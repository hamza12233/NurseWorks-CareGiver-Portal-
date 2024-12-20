class UserDoc < ApplicationRecord

    TYPES = [
        "Drivers License",
        "SSN card",
        "CNA license",
        "Insurance card",
        "Doctors note",
        "Jury duty notification",
        "Covid vaccine appt",
        "Texas state benefits",
        "Medical Assistant",
        "Other"
    ]

    validates_presence_of :attachment, message: "required"

    belongs_to :user, optional: true
    belongs_to :document_type
    has_one_attached :attachment

    validate :acceptable_attachment

    def acceptable_attachment
        if self.attachment.present?
            unless self.attachment.byte_size <= 5.megabyte
                errors.add(:attachment, "is too big. Must be less than 5 MB")
            end
        end
    end

end
