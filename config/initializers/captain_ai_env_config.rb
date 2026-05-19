# frozen_string_literal: true

# Seeds Captain AI configuration from environment variables on startup.
# Only sets values that are not already configured in the database (Admin UI values take precedence).
Rails.application.config.after_initialize do
  env_mappings = {
    'CAPTAIN_OPEN_AI_API_KEY' => ENV.fetch('CAPTAIN_OPEN_AI_API_KEY', nil),
    'CAPTAIN_OPEN_AI_ENDPOINT' => ENV.fetch('CAPTAIN_OPEN_AI_ENDPOINT', nil),
    'CAPTAIN_OPEN_AI_MODEL' => ENV.fetch('CAPTAIN_OPEN_AI_MODEL', nil),
    'CAPTAIN_EMBEDDING_MODEL' => ENV.fetch('CAPTAIN_EMBEDDING_MODEL', nil),
    'CAPTAIN_EMBEDDING_API_KEY' => ENV.fetch('CAPTAIN_EMBEDDING_API_KEY', nil),
    'CAPTAIN_EMBEDDING_ENDPOINT' => ENV.fetch('CAPTAIN_EMBEDDING_ENDPOINT', nil)
  }

  env_mappings.each do |name, value|
    next if value.blank?

    existing = InstallationConfig.find_by(name: name)
    next if existing&.value.present?

    InstallationConfig.find_or_initialize_by(name: name).tap do |config|
      config.value = value
      config.locked = false
      config.save!
    end
  end
rescue StandardError => e
  Rails.logger.error "Failed to seed Captain AI config from ENV: #{e.message}"
end
