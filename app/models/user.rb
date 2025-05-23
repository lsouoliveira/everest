class User
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::SecurePassword

  attr_accessor :id, :name, :email, :created_at, :password_digest

  has_secure_password

  validates :name, presence: true, length: { minimum: 5, maximum: 128 }
  validates :email, presence: true, email: true
  validates :password, presence: true, length: { minimum: 10, maximum: 72 }, password: true

  validate :email_is_unique

  def self.create(attributes)
    user = new(id: SecureRandom.uuid, created_at: Time.zone.now, **attributes)

    $user_repository.save(user) if user.valid?

    user
  end

  def self.authenticate_by(attributes)
    user = $user_repository.find_by_email(attributes[:email])

    if user.authenticate(attributes[:password])
      user
    else
      nil
    end
  rescue UserRepository::NotFound
    nil
  end

  private
  def email_is_unique
    user = $user_repository.find_by_email(email)

    if user.id != id
      errors.add(:email, :taken)
    end
  rescue UserRepository::NotFound
  end
end
