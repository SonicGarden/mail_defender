# frozen_string_literal: true

RSpec.describe MailDefender do
  let(:message) do
    Struct.new(:perform_deliveries, :to, :cc, :bcc, keyword_init: true).new
  end

  describe '#delivering_email' do
    context 'deliver_emails_to is a array of strings' do
      it 'Only different addresses are forwarded' do
        interceptor = MailDefender::Interceptor.new(forward_emails_to: 'test@example.com', deliver_emails_to: ['a@wheel.com', 'd@club.com', 'john@gmail.com'])
        message.to = [
          'a@wheel.com', 'b@wheel.com', 'c@pump.com', 'd@club.com', 'e@gmail.com', 'john@gmail.com', 'sam@gmail.com'
        ]
        interceptor.delivering_email(message)
        expect(message.to).to eq ['a@wheel.com', 'd@club.com', 'john@gmail.com', '"Orig to: b@wheel.com,c@pump.com,e@gmail.com,sam@gmail.com" <test@example.com>']
      end
    end

    context 'deliver_emails_to is a array of strings and regexp' do
      it 'Unmatched addresses are forwarded' do
        interceptor = MailDefender::Interceptor.new(forward_emails_to: 'test@example.com', deliver_emails_to: [/@wheel\.com$/, /@pump\.com$/, 'john@gmail.com'])
        message.to = [
          'a@wheel.com', 'b@wheel.com', 'c@pump.com', 'd@club.com', 'e@gmail.com', 'john@gmail.com', 'sam@gmail.com'
        ]
        interceptor.delivering_email(message)
        expect(message.to).to eq ['a@wheel.com', 'b@wheel.com', 'c@pump.com', 'john@gmail.com', '"Orig to: d@club.com,e@gmail.com,sam@gmail.com" <test@example.com>']
      end
    end

    context 'forward_emails_to is a empty' do
      it 'Sent only to matched addresses' do
        interceptor = MailDefender::Interceptor.new(deliver_emails_to: [/@wheel\.com$/, /@pump\.com$/, 'john@gmail.com'])
        message.to = [
          'a@wheel.com', 'b@wheel.com', 'c@pump.com', 'd@club.com', 'e@gmail.com', 'john@gmail.com', 'sam@gmail.com'
        ]
        interceptor.delivering_email(message)
        expect(message.to).to eq ['a@wheel.com', 'b@wheel.com', 'c@pump.com', 'john@gmail.com']
      end
    end
  end
end
