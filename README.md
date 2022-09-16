# Mail Defender

This gem intercepts and forwards email to a forwarding address in a non-production environment. This is to ensure that in staging or in development by mistake we do not deliver emails to the real people.
However we need to test emails time to time.

## Usage

```rb
# There is no need to include this gem for production or for test environment
gem 'mail_defender', group: [:development, :staging]
```

```rb
# config/initializers/mail_defender.rb
if Rails.env.development? || Rails.env.staging?
  ActiveSupport.on_load(:action_mailer) do
    register_interceptor(MailDefender.new({
      forward_emails_to: 'intercepted_emails@domain.com',
      deliver_emails_to: [/@wheel\.com$/, 'tester@allowed.test']
    }))
  end
end
```

Sending mail to `xxx@deny.test` with the above settings will actually send mail to `"Orig to: xxx@deny.test" <intercepted_emails@domain.com>`.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Thanks
Inspired by [mail\_interceptor](https://github.com/bigbinary/mail_interceptor).
