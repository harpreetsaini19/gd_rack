class DriveSpreadsheet

  attr_reader :worksheets

  def initialize(spreadsheet_key)
    @worksheets = get_google_worksheets(spreadsheet_key)
  end

  private

    def drive_session
      GoogleDrive.saved_session("config.json")
    end

    def get_google_worksheets(spreadsheet_key)
      drive_session.spreadsheet_by_key(spreadsheet_key).worksheets
    end

end
