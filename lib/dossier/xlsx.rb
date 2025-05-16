module Dossier
  class Xlsx
    def initialize(collection, headers = nil)
      @headers    = headers || collection.shift
      @collection = collection
    end

    def each
      Tempfile.create(['dossier', '.xlsx']) do |tempfile|
        workbook  = FastExcel.open(tempfile.path, constant_memory: true)
        worksheet = workbook.add_worksheet("Sheet1")

        worksheet.append_row(@headers)
        @collection.each { |row| worksheet.append_row(row) }

        workbook.close

        # Now stream the XLSX file in chunks
        File.open(tempfile.path, 'rb') do |file|
          while chunk = file.read(16 * 1024) # 16KB chunks
            yield chunk
          end
        end
      end
    end
  end
end
