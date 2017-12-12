# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'TasksWS' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TasksWS
  pod 'BFKit-Swift'
  pod 'MBProgressHUD', '~> 1.1.0' #progress bar
  pod 'IQKeyboardManagerSwift'
  pod 'EasyRest' #api rest
  pod 'EasyRest/LoggerBeaver' #api rest
  pod 'KeychainSwift' #key chain
  pod 'DatePickerDialog' #date picker
  pod 'RealmSwift' # banco de dados
  pod 'Reachability' #verifica internet

end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        compatibility_pods = ['Genome']
        if compatibility_pods.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end
