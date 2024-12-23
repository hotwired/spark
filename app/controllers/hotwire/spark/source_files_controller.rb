class Hotwire::Spark::SourceFilesController < ActionController::Base
  def show
    if File.exist?(path_param)
      render plain: File.read(path_param)
    else
      head :not_found
    end
  end

  private
    def path_param
      Rails.root.join params[:path]
    end
end
