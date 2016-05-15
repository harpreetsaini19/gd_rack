require 'drive_spreadsheet'
require 'locales_hash_creator'
require 'locales_yml_creator'
require 'locales_csv_creator'

namespace :locales_yml do

  desc "Generate locales yml from google drive spreadsheet"
  task :generator, [:spreadsheet_key] do|t, options|
    spreadsheet_key = options[:spreadsheet_key] || default_spreadsheet_key
    drive_spreadsheet = DriveSpreadsheet.new(spreadsheet_key)
    worksheets_hash = LocalesHashCreator.new(drive_spreadsheet).worksheets_hash
    yml_creator = LocalesYmlCreator.new(worksheets_hash)
    yml_creator.generate_ymls
    yml_files = yml_creator.yml_files
    display_confirmation(yml_files, "yml", "Change the default locale as per requirement.")
  end

  def default_spreadsheet_key
    "14bEZw-t-pD7cGQ3MbTVWoFxwcuLDLINsEtGd6BIzYLc"
  end

end

namespace :locales_csv do

  desc "Generate locales csv from locales yml"
  task :generator => "locales_yml:generator" do
    locales_paths = Dir["#{Rails.root}/config/locales/**/*.yml"]
    csv_creator = LocalesCsvCreator.new(locales_paths)
    csv_creator.generate_csvs
    csv_files = csv_creator.csv_files
    display_confirmation(csv_files, "csv")
  end

end


def display_confirmation(files, type, message = "")
  puts "Following #{files.count} #{type} locales files created."
  files.each do|file|
    puts "=> #{file}"
  end
  puts message
end


