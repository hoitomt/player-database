class ApiKey < ActiveRecord::Base
  belongs_to :user

  before_create :generate_access_token

  validates :user, presence: true

  def update_access_token
    new_token = generate_access_token
    self.update_attributes(access_token: new_token)
    new_token
  end

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
    self.access_token
  end
end
