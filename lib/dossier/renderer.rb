module Dossier
  class Renderer
    attr_reader :report
    attr_writer :engine

    # Conditional for Rails 4.1 or < 4.1 Layout module
    Layouts = defined?(ActionView::Layouts) ? ActionView::Layouts : AbstractController::Layouts

    def initialize(report)
      @report = report
    end

    def render(options = {})
      render_template :custom, options
    rescue ActionView::MissingTemplate => _e
      render_template :default, options
    end

    def engine
      @engine ||= Engine.new(report)
    end

    private

    def render_template(template, options)
      template = send("#{template}_template_path")
      engine.render options.merge(template: template, locals: {report: report})
    end

    def template_path(template)
      "dossier/reports/#{template}"
    end

    def custom_template_path
      template_path(report.template)
    end

    def default_template_path
      template_path('show')
    end

    class Engine < AbstractController::Base
      include AbstractController::Rendering
      include Renderer::Layouts
      include ViewContextWithReportFormatter

      attr_reader :report
      ActiveSupport.on_load(:action_controller) do
        config.cache_store = ActionController::Base.cache_store
      end

      layout 'dossier/layouts/application'

      def render_to_body(options = {})
        renderer = ActionView::Renderer.new(lookup_context)
        renderer.render(view_context, options)
      end

      def self._helpers
        Module.new do
          include Rails.application.helpers
          include Rails.application.routes.url_helpers

          def default_url_options
            {}
          end
        end
      end

      def self._view_paths
        ActionController::Base.view_paths
      end

      def initialize(report)
        @report = report
        super()
      end
    end
  end
end
