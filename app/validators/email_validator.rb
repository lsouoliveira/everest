class EmailValidator < ActiveModel::EachValidator
  ALLOWED_LOCAL_PART_SYMBOLS = "#$%&'*+-/=?^_`{|}~."

  def validate_each(record, attribute, value)
    return if value.blank?

    local_part, domain = value.split("@", 2)

    validate_local_part(record, local_part) &&
      validate_domain(record, domain)
  end

  private
  def validate_local_part(record, local_part)
    validate_local_part_length(record, local_part) &&
      validate_local_part_format(record, local_part)
  end

  def validate_local_part_length(record, local_part)
    return false if local_part.nil?
    return true if local_part.length <= 64

    record.errors.add(:email, :local_part_too_long)

    false
  end

  def validate_local_part_format(record, local_part)
    return true if local_part =~ /\A[a-zA-Z0-9#{Regexp.escape(ALLOWED_LOCAL_PART_SYMBOLS)}]+\z/

    record.errors.add(:email, :local_part_invalid)

    false
  end

  def validate_domain(record, domain)
    validate_domain_length(record, domain) &&
      validate_domain_format(record, domain)
  end

  def validate_domain_length(record, domain)
    return false if domain.nil?
    return true if domain.length <= 128

    record.errors.add(:email, :domain_too_long)

    false
  end

  def validate_domain_format(record, domain)
    return true if domain =~ /\A[a-zA-Z0-9.-]+\z/

    record.errors.add(:email, :domain_invalid)

    false
  end
end
