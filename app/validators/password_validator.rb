class PasswordValidator < ActiveModel::EachValidator
  SPECIAL_CHARACTERS = " !\"#$%&'()*+,-./:;<=>?@[\]^_`{|}~"

  def validate_each(record, attribute, value)
    return if value.blank?

    validate_includes_two_digits(record, value)
    validate_includes_two_special_characters(record, value)
    validate_includes_two_uppercase_letters(record, value)
    validate_includes_two_lowercase_letters(record, value)
  end

  private
  def validate_includes_two_digits(record, value)
    return if value.scan(/\d/).size >= 2

    record.errors.add(:password, :password_must_include_two_digits)
  end

  def validate_includes_two_special_characters(record, value)
    return if value.scan(/[#{Regexp.escape(SPECIAL_CHARACTERS)}]/).size >= 2

    record.errors.add(:password, :password_must_include_two_special_characters)
  end

  def validate_includes_two_uppercase_letters(record, value)
    return if value.scan(/[A-Z]/).size >= 2

    record.errors.add(:password, :password_must_include_two_uppercase_letters)
  end

  def validate_includes_two_lowercase_letters(record, value)
    return if value.scan(/[a-z]/).size >= 2

    record.errors.add(:password, :password_must_include_two_lowercase_letters)
  end
end
