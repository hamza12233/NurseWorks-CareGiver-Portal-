class User < ApplicationRecord

  ThinkingSphinx::Callbacks.append(
        self, :behaviours => [:real_time]
    )
    
  validates :first_name, :last_name, :email, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :support_requests
  has_many :user_docs

  has_rich_text :bio
  
  has_one_attached :profile_image, dependent: :destroy

  before_create :setup_role

  def full_name
    first_name + " " + last_name
  end
  
  def setup_role
    self.role = "User"
  end

end
