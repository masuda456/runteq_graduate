module ApplicationHelper
  def error_message_for(object, field)
    if object.errors[field].present?
      content_tag(:div, object.errors[field].join(", "), class: "text-danger")
    end
  end
end
