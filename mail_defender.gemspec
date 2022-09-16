# frozen_string_literal: true

require_relative "lib/mail_defender/version"

Gem::Specification.new do |spec|
  spec.name = "mail_defender"
  spec.version = MailDefender::VERSION
  spec.authors = ["aki77"]
  spec.email = ["aki77@users.noreply.github.com"]

  spec.summary = "Intercepts and forwards emails."
  spec.homepage = "https://github.com/SonicGarden/mail_defender"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/SonicGarden/mail_defender"
  spec.metadata["changelog_uri"] = "https://github.com/SonicGarden/mail_defender/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_runtime_dependency 'activesupport', '>= 6.1'
  spec.add_runtime_dependency 'actionmailer', '>= 6.1'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
