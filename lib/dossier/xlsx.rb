module Dossier
  class Xlsx
    def initialize(collection, headers = nil)
      @headers    = headers || collection.shift
      @collection = collection
    end

    def each
      io = StringIO.new
      workbook  = FastExcel.open(io, constant_memory: true)
      worksheet = workbook.add_worksheet("Sheet1")

      worksheet.append_row(@headers)
      @collection.each { |row| worksheet.append_row(row) }

      workbook.close
      io.rewind

      # yield in binary chunks (e.g. 16KB) to support streaming
      while (chunk = io.read(16 * 1024))
        yield chunk
      end
    end
  end
end
