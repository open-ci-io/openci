require 'xcodeproj'

# プロジェクトのパス（ここでは ios/Runner.xcodeproj を使用）
project_path = 'ios/Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# 最初のターゲットの全ビルド設定を変更
target = project.targets.first
target.build_configurations.each do |config|
  config.build_settings['CODE_SIGN_STYLE']                = 'Manual'
  config.build_settings['DEVELOPMENT_TEAM']               = 'T4W85DPBVX'
  config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = 'OpenCI PP'
end

project.save
