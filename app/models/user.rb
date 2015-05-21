class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, request_keys: [:subdomain]

  acts_as_followable
  acts_as_follower

  # serialize attribtues
  serialize :properties,    ActiveRecord::Coders::NestedHstore

  # enum
  enum role:              [:user, :corp_admin, :admin]
  enum employment_type:   [:full_time, :part_time, :contractor]
  enum status:            [:active, :terminated]



  belongs_to  :company


  def set_default_role
    self.role ||= :user
  end

  def short_name
    self.name ? self.name.split(' ').map{|w| w.first}.join.upcase : ''
  end

  def name
    [first_name, last_name].compact * ' '
  end


end
