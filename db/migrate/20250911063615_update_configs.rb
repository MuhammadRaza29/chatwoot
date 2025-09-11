class UpdateConfigs < ActiveRecord::Migration[7.1]
  def change
    installation_config = InstallationConfig.find_by(name: 'INSTALLATION_NAME')
    installation_config.value = 'LocalCom'
    installation_config.save!

    installation_config = InstallationConfig.find_by(name: 'BRAND_URL')
    installation_config.value = 'https://localcom.com.au'
    installation_config.save!

    installation_config = InstallationConfig.find_by(name: 'WIDGET_BRAND_URL')
    installation_config.value = 'https://localcom.com.au'
    installation_config.save!

    installation_config = InstallationConfig.find_by(name: 'BRAND_NAME')
    installation_config.value = 'LocalCom'
    installation_config.save!

    installation_config = InstallationConfig.find_by(name: 'TERMS_URL')
    installation_config.value = 'https://localcom.com.au/policies'
    installation_config.save!

    installation_config = InstallationConfig.find_by(name: 'PRIVACY_URL')
    installation_config.value = 'https://localcom.com.au/wp-content/uploads/2025/06/Privacy-Policy-LocalCom-1.pdf'
    installation_config.save!
  end
end
