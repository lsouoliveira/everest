class CustomFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options = {})
    options[:class] = "form-control form-control-lg #{options[:class]}"
    options[:class] = "is-invalid #{options[:class]}" if error_for?(method)
    super(method, options)
  end

  def email_field(method, options = {})
    options[:class] = "form-control form-control-lg #{options[:class]}"
    options[:class] = "is-invalid #{options[:class]}" if error_for?(method)
    super(method, options)
  end

  def label(method, text = nil, options = {})
    options[:class] = "form-label #{options[:class]}"
    super(method, text, options)
  end

  def password_field(method, options = {})
    options[:class] = "form-control form-control-lg #{options[:class]}"
    options[:class] = "is-invalid #{options[:class]}" if error_for?(method)
    super(method, options)
  end

  def submit(value = nil, options = {})
    options[:class] = "btn btn-primary btn-lg #{options[:class]}"
    super(value, options)
  end

  def error_message_for(method, **options)
    if object.errors[method].any?
      @template.tag.div(class: "alert alert-danger mt-2", **options) do
        object.errors.full_messages_for(method).to_sentence
      end
    end
  end

  private
  def error_for?(method)
    return false if object.blank?

    object.errors[method].any?
  end
end
