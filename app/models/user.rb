class User < ApplicationRecord

  attr_accessor :start_date, :end_date
  
  validates :first_name, :last_name, :email, :phone, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = ["User", "Manager", "Super User"]
  ADMIN_ROLES = ["Super User", "Manager"]

  has_many :support_requests, dependent: :delete_all
  has_many :user_docs, dependent: :delete_all
  has_many :assign_support_requests

  has_rich_text :bio

  has_one_attached :profile_image

  before_create :setup_role

  def full_name
    first_name + " " + last_name
  end

  def setup_role
    self.role = "User"
    self.deactivated = false
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_now
  end

  def active_for_authentication?
    super && !deactivated
  end

  def active_status
    self.deactivated ? "No" : "Yes"
  end

  validate :acceptable_profile_image

  def acceptable_profile_image
      return unless profile_image.attached?

      unless profile_image.byte_size <= 10.megabyte
          errors.add(:profile_image, "is too big. Must be less than 10 MB")
      end
  end

end
