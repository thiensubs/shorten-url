# frozen_string_literal: true

module FlashHelper
  ALERT_TYPES = [:success, :standard, :secondary, :alert] unless const_defined?(:ALERT_TYPES)
  def flash_messages(options = {})
    flash_messages = []
    flash.each do |type, message|
      type = type.to_sym
      type = :info if type == :notice
      type = :error   if type == :alert
      text = "<script>toastr.#{type}(#{message.inspect});</script>"
      flash_messages << text.html_safe if message
    end
    flash.clear()
    flash_messages.join("\n").html_safe
  end
end