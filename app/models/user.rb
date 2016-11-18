class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :api_key
  has_many :teams

  delegate :access_token, to: :api_key, allow_nil: true

  def self.find_by_access_token(access_token)
    api_key = ApiKey.find_by_access_token(access_token)
    api_key ? api_key.user : nil
  end

  def generate_api_key
    if self.api_key
      self.api_key.update_access_token
    else
      ApiKey.create!(user: self).access_token
    end
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

end
