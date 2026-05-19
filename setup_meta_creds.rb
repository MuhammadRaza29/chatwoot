# setup_meta_creds.rb

configs = {
  # --- Facebook & Instagram Settings ---
  'FB_APP_ID' => '738051402658505',
  'FB_APP_SECRET' => 'f5cef7e25f4c461c8886478f664e6d2d',
  'FB_VERIFY_TOKEN' => 'chatwoot_fb_token_2026428',

  # --- WhatsApp Embedded Settings ---
  'WHATSAPP_APP_ID' => '738051402658505',
  'WHATSAPP_APP_SECRET' => 'f5cef7e25f4c461c8886478f664e6d2d',
  'WHATSAPP_CONFIGURATION_ID' => '823015107537954'
}

puts "Injecting Meta & WhatsApp Credentials into the Database..."

configs.each do |key, val|
  # Find the existing config or create a new one, then update its value
  config = InstallationConfig.find_or_initialize_by(name: key)
  config.value = val
  config.save!
  puts "Successfully updated #{key}"
end

# Clear Chatwoot's internal cache so it immediately recognizes the new DB values
GlobalConfig.clear_cache
puts "Cache cleared. Setup complete."