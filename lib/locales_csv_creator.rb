require 'csv'

class LocalesCsvCreator

  attr_reader :csv_files

  def initialize(locales_paths)
    @locales_paths = locales_paths
    @csv_files = []
  end

  def generate_csvs
    @csv_file_paths = @locales_paths.map{|i| "#{File.dirname(i)}/#{File.basename(File.dirname(i))}.csv"}.uniq
    @csv_file_paths.each do|file_path|
      generate_csv_file(file_path)
      relative_file_path = file_path.gsub(Rails.root.to_s, "")
      @csv_files << relative_file_path
    end
  end

  private

    def generate_csv_file(file_path)
      current_dir = File.dirname(file_path)
      csv_data = []
      yml_files(current_dir).each do|yml_file|
        csv_data += generate_csv_data(yml_file)
      end
      CSV.open(file_path, 'wb') do|csv|
        csv_data.each do|data_row|
          csv << data_row
        end
      end
    end

    def generate_csv_data(yml_file)
      yml_hash = YAML.load(File.open(yml_file))
      data = []
      yml_hash_to_csv_data(yml_hash, data)
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
        data << [keys.join('.'), obj]
      end
    end

    def yml_files(current_dir)
      Dir["#{current_dir}/*.yml"]
    end
end
