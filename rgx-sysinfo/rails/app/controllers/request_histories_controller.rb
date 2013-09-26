class RequestHistoriesController < ApplicationController

  # POST /request_history
  def create
    hash = JSON.parse(request.raw_post)
    @request_history = RequestHistory.new().update_from(hash)
    respond_to do |format|
      if @request_history.save
        format.json { head :ok }
      else
        format.json { render json: @request_history.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def delete_all
    RequestHistory.delete_all
    redirect_to controller: 'dashboard', action: 'index'
  end
  
end
