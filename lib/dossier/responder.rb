require 'responders' unless defined? ::ActionController::Responder

module Dossier
  class Responder < ::ActionController::Responder
    alias :report :resource

    def to_html
      report.renderer.engine   = controller
      controller.response_body = report.render
    end

    def to_json
      set_content_type!('text/json')
      controller.render json: report.results.hashes
    end

    def to_csv
      set_content_disposition!
      set_content_type!('text/csv')
      controller.response_body = StreamCsv.new(*collection_and_headers(report.raw_results.arrays))
    end

    def to_xls
      set_content_disposition!
      set_content_type!('application/xls')
      controller.response_body = Xls.new(*collection_and_headers(report.raw_results.arrays))
    end

    def to_xlsx
      set_content_disposition!
      set_content_type!('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
      controller.response_body = Xlsx.new(*collection_and_headers(report.raw_results.arrays))
    end

    def respond
      multi_report_html_only!
      super
    end

    private

    def set_content_disposition!
      controller.headers["Content-Disposition"] = %[attachment;filename=#{filename}]
    end

    def set_content_type!(type)
      controller.headers["Content-Type"] = %[#{type}; charset=utf-8]
    end

    def collection_and_headers(collection)
      headers = collection.shift.map { |header| report.format_header(header) }
      [collection, headers]
    end

    def filename
      "#{report.class.filename}.#{format}"
    end

    def multi_report_html_only!
      if report.is_a?(Dossier::MultiReport) and format.to_s != 'html'
        raise Dossier::MultiReport::UnsupportedFormatError.new(format)
      end
    end
  end
end
