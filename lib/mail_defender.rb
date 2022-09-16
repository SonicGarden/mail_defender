# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/array'
require 'action_mailer'
require_relative 'mail_defender/version'

class MailDefender
  attr_accessor :deliver_emails_to, :forward_emails_to, :recipients

  def initialize(options = {})
    @deliver_emails_to = Array.wrap(options[:deliver_emails_to])
    @forward_emails_to = Array.wrap(options[:forward_emails_to])
    @recipients = []
  end

  def delivering_email(message)
    @recipients = Array.wrap(message.to)
    to_emails_list = normalize_recipients

    message.perform_deliveries = to_emails_list.present?
    message.to  = to_emails_list
  end

  private

  def normalize_recipients
    normalized_recipients = filter_by_deliver_emails_to
    forward_recipients = forward_recipients_by_normalized_recipients(normalized_recipients)

    [normalized_recipients, forward_recipients].flatten.uniq.reject(&:blank?)
  end

  def filter_by_deliver_emails_to
    return [] if deliver_emails_to.empty?

    recipients.select do |recipient|
      deliver_emails_to.any? { |deliver_email| deliver_email === recipient }
    end
  end

  def forward_recipients_by_normalized_recipients(normalized_recipients)
    intercepted_recipients = recipients - normalized_recipients
    return [] if intercepted_recipients.empty?

    forward_emails_to.map do |email|
      ActionMailer::Base.email_address_with_name(email, "Orig to: #{intercepted_recipients.join(',').truncate(100)}")
    end
  end
end
