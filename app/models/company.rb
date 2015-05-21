# == Schema Information
#
# Table name: public.companies
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  url         :string(255)
#  description :text
#  logo        :string(255)
#  details     :text
#  plan_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  email       :string(255)
#  status      :string(255)      default("new")
#  token       :string(255)
#

class Company < ActiveRecord::Base
  extend Enumerize
  include Concerns::Company::Tenant
  include Concerns::Company::AutoSeed

  # capabilities
  acts_as_followable
  enumerize :status,  in: Enum::Company::STATUS[:options],
                      default: Enum::Company::STATUS[:default],
                      predicates: { prefix: true }

  # relationships
  belongs_to :plan, class_name:"Plan"
  has_many :users,              dependent: :destroy
  has_many :teams,              dependent: :destroy
  has_many :timeoff_policies,   dependent: :destroy
  has_many :locations,          dependent: :destroy
  has_many :hrdates,            dependent: :destroy
  has_many :tasks,              through: :users
  has_many :forms,              dependent: :destroy
  has_many :form_entries,       through: :forms, source: :entries
  has_many :embedded_forms,     dependent: :destroy


  # validations
  # validates :name,  presence: true
  validates :url,   presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: /\A[a-zA-Z0-9]+\Z/ },
                    on: :update
  validates :email, presence: true,
                    email: true,
                    uniqueness: { case_sensitive: false }
  validate :company_tenant, on: :update


  # callbacks
  before_validation :generate_token,  on: :create
  before_validation :downcase_url,    on: :update
  after_create :send_welcome_notification

  def send_welcome_notification
    CompanyMailer.welcome_notification(self.id).deliver
  end

  def default_policy
    @default_policy ||= (timeoff_policies.first || generate_default_timeoff_policy)
  end

  protected

  def downcase_url
    self.url = url.downcase if url.present?
  end

  # should generate token for confirmation
  #
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Company.exists?(token: random_token)
    end
  end


  # custom validation for company tenant (or company.url)
  #
  def company_tenant
    if self.url_changed? && self.url_was.present?
      errors[:url] << "can't be changed"
      false
    end
  end

end
