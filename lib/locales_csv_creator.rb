require 'csv'

class LocalesCsvCreator

  attr_reader :csv_files

  def initialize(locales_paths)
    @locales_paths = locales_paths
    @csv_files = []
  end

  def generate_csvs
    @csv_file_paths = @locales_paths.map{|i| "#{file_dir(i)}/#{file_basename(file_dir(i))}.csv"}.uniq
    @csv_file_paths.each do|file_path|
      generate_csv_file(file_path)
      relative_file_path = file_path.gsub(Rails.root.to_s, "")
      @csv_files << relative_file_path
    end
  end

  private

    def generate_csv_file(file_path)
      current_dir = file_dir(file_path)
      header_row = ["Category", "keys"]
      csv_data = {}
      keys = []
      yml_files(current_dir).each do|yml_file|
        locale_name = file_basename(yml_file)
        header_row << locale_name
        csv_data[locale_name] = generate_csv_data(locale_name, yml_file)
        keys = csv_data[locale_name].keys if keys.empty?
      end
      CSV.open(file_path, 'wb') do|csv|
        previous_category = ""
        csv << header_row
        keys.each do|key|
          key_array = key.split('.')
          present_category = key_array[-2] || key_array[0]
          csv_row = []
          csv_row << (previous_category == present_category ? "" : present_category.titleize)
          csv_row << key
          header_row[2..-1].each do|locale|
            csv_row << csv_data[locale][key]
          end
          csv << csv_row
          previous_category = present_category
        end
      end
    end

    def generate_csv_data(locale_name, yml_file)
      yml_hash = YAML.load(File.open(yml_file))
      data = {}
      yml_hash_to_csv_data(yml_hash[locale_name], data)
      data
    end

    def yml_hash_to_csv_data(obj, data, keys = [])
      case obj
      when Hash
        obj.each do |k,v|
          keys << k
          yml_hash_to_csv_data(v, data, keys)
          keys.pop
        end
      else
        data[keys.join('.')] = obj
      end
    end

    def yml_files(current_dir)
      Dir["#{current_dir}/*.yml"]
    end

    def file_dir(file)
      File.dirname(file)
    end

    def file_basename(file)
      File.basename(file, ".*")
    end
end
