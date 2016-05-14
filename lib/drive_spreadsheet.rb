class DriveSpreadsheet

  attr_reader :worksheets

  def initialize(spreadsheet_key)
    session = google_drive_session
    @worksheets = get_google_worksheets(session, spreadsheet_key)
  end

  private

    def google_drive_session
      GoogleDrive.saved_session("config.json")
    end

    def get_google_worksheets(session, spreadsheet_key)
      session.spreadsheet_by_key(spreadsheet_key).worksheets
    end

end
