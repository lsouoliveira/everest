class CustomFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options = {})
    options[:class] = "form-control form-control-lg #{options[:class]}"
    super(method, options)
  end

  def email_field(method, options = {})
    options[:class] = "form-control form-control-lg #{options[:class]}"
    super(method, options)
  end

  def label(method, text = nil, options = {})
    options[:class] = "form-label #{options[:class]}"
    super(method, text, options)
  end

  def password_field(method, options = {})
    options[:class] = "form-control form-control-lg #{options[:class]}"
    super(method, options)
  end

  def submit(value = nil, options = {})
    options[:class] = "btn btn-primary btn-lg #{options[:class]}"
    super(value, options)
  end

  def error_message_for(method)
    if object.errors[method].any?
      @template.tag.div(class: "alert alert-danger") do
        object.errors[method].full_messages.first
      end
    end
  end
end
