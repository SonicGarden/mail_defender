# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/array'
require 'action_mailer'
require_relative 'mail_defender/version'

class MailDefender
  attr_reader :deliver_emails_to, :forward_emails_to

  def initialize(deliver_emails_to: [], forward_emails_to: [])
    @deliver_emails_to = Array.wrap(deliver_emails_to)
    @forward_emails_to = Array.wrap(forward_emails_to)
  end

  def delivering_email(message)
    message.to = normalize_recipients(message, :to)
    message.cc = normalize_recipients(message, :cc)
    message.bcc = normalize_recipients(message, :bcc)
  end

  private

  def normalize_recipients(message, field)
    recipients = Array.wrap(message.public_send(field))
    allowed_recipients, denyed_recipients = filter_recipients(recipients)
    forward_recipients = forward_recipients_by_denyed_recipients(denyed_recipients, field)

    [allowed_recipients, forward_recipients].flatten.uniq.reject(&:blank?)
  end

  def filter_recipients(recipients)
    return [[], []] if deliver_emails_to.empty?

    recipients.partition do |recipient|
      deliver_emails_to.any? { |deliver_email| deliver_email === recipient }
    end
  end

  def forward_recipients_by_denyed_recipients(denyed_recipients, field)
    return [] if denyed_recipients.empty?

    forward_emails_to.map do |email|
      ActionMailer::Base.email_address_with_name(email, "Orig #{field}: #{denyed_recipients.join(',').truncate(100)}")
    end
  end
end
