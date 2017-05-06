class Accounting::ManualTransactionsController < ApplicationController
  
  def index
    @manual_transactions = ManualTransaction.where('updated_at > ?', SchoolYear.current_school_year.previous_school_year.early_registration_start_date)
    @manual_transactions.sort! {|a, b| b.updated_at <=> a.updated_at}
  end
  
  def new
    if request.post? || request.put?
      # Remove transaction_by from params before creating the new ManualTransaction object due to type incompatibility (string v.s. integer)
      selected_transaction_by_id = params[:manual_transaction].delete :transaction_by
      @manual_transaction = ManualTransaction.new params[:manual_transaction]
      @manual_transaction.transaction_by_id = selected_transaction_by_id.to_i unless selected_transaction_by_id.blank?
      @manual_transaction.recorded_by = @user.person
      if @manual_transaction.save_with_side_effects
        flash[:notice] = 'Manual Transaction added successfully'
        redirect_to controller: 'registration/people', action: :show, id: @manual_transaction.student_id
      end
    else
      @manual_transaction = ManualTransaction.new
      @manual_transaction.student = Person.find params[:student_id].to_i
      @manual_transaction.transaction_date = PacificDate.today
    end
  end
  
  def show
    @manual_transaction = ManualTransaction.find params[:id].to_i
  end
end
