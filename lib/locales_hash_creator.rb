class LocalesHashCreator

  attr_reader :worksheets_hash

  def initialize(drive_spreadsheet)
    @worksheets = drive_spreadsheet.worksheets
    @worksheets_hash = generate_worksheets_hash
  end

  private

    def generate_worksheets_hash
      worksheets_hash = {}
      @worksheets.each do|worksheet|
        worksheets_hash[worksheet.title] = generate_worksheet_hash(worksheet)
      end
      worksheets_hash
    end

    def generate_worksheet_hash(worksheet)
      worksheets_rows = worksheet.rows
      header_row = worksheets_rows.first
      worksheet_hash = {}
      header_row[worksheet_locales_starting_index..-1].each_with_index do|locale, index|
        worksheet_column_index = index + worksheet_locales_starting_index
        worksheet_hash[locale] = generate_locale_hash(worksheets_rows, worksheet_column_index, locale)
      end
      worksheet_hash
    end

    def generate_locale_hash(worksheets_rows, worksheet_column_index, locale)
      locale_hash = {}
      worksheets_rows[1..-1].each do|row|
        locale_key = row.second
        locale_key_value = row[worksheet_column_index]
        key_elements = locale_key.split(".")
        locale_hash[locale] = generate_key_elements_hash(key_elements, locale_key_value, locale_hash[locale] || {})
      end
      locale_hash
    end

    def generate_key_elements_hash(elements, value, key_elements_hash)
      if elements.length == 1
        return { elements.first => value }
      else
        if key_elements_hash.has_key?(elements.first)
          key_elements_hash[elements.first].merge!(generate_key_elements_hash(elements[1..-1], value, key_elements_hash[elements.first])) {|key, hash1, hash2| hash1.merge!(hash2)}
        else
          key_elements_hash[elements.first] = generate_key_elements_hash(elements[1..-1], value, {})
        end
      end
      return key_elements_hash
    end

    def worksheet_locales_starting_index
      2
    end

end
