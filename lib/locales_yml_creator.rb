require 'fileutils'

class LocalesYmlCreator

  attr_reader :yml_files

  def initialize(worksheets_hash)
    @worksheets_hash = worksheets_hash
    @yml_files = []
  end

  def generate_ymls
    @worksheets_hash.each do|dir_name, files_hash|
      dir_path = mkdir(dir_name)
      files_hash.each do|file_name, content|
        file_path = "#{dir_path}/#{file_name}.yml"
        mkfile(file_path, content)
        relative_file_path = file_path.gsub(Rails.root.to_s, "")
        @yml_files << relative_file_path
      end
    end
  end

  private

    def locals_root_path
      "#{Rails.root}/config/locales/"
    end

    def mkdir(dir_name)
      direcory_path = File.realdirpath(locals_root_path + dir_name)
      FileUtils.mkdir_p(direcory_path) unless File.directory?(direcory_path)
      direcory_path
    end

    def mkfile(file_path, content)
      File.open(file_path, 'w') do|file|
        file.write(content.to_yaml)
      end
    end
end
